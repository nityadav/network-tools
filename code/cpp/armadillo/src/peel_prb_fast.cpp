#define ARMA_NO_DEBUG // this avoids checking the boundary conditions while accessing vectors and matrices, hence helping in speed-up

#include <armadillo>
#include <fstream>
#include <iostream>
#include <string>

using namespace arma;
using std::ifstream;
using std::ofstream;
using std::string;
using std::cout;

//---------------------------- this function is used to read the graph from pajek files------------------------------------------------------
void readPajek(ifstream& file, int num_nodes, mat* adj, vec* deg) {

	bool skip = true;
	while(file.good())
	{
		char buff[256];
		file.getline(buff, 255);
		string line = buff;
		if(line == "*Edges")
		{
			skip = false;
		}
		else if(line == "*Arcs")
		{
			skip = false;
		}
		else if(!skip)
		{
			int s = -1, d = -1;
			double w = 1.0;
			sscanf(buff, "%d %d %lf", &s, &d, &w);
			if(s != -1 && d != -1)
			{
				(*adj)(s-1,d-1) = w;
				(*adj)(d-1,s-1) = w;
				(*deg)(s-1)++;
				(*deg)(d-1)++;
			}
		}
	}
	file.close();
	//printf("%s\n", "Finished reading the graph file");
}

//-------------------------------------- find the seed set given a seed---------------------------------------------------------------------
mat nbr_seed_selection(mat *adj, uword seed, uword num_nodes, uword limit, vec flags) {

	uvec first_nbrs = find((*adj).col(seed));
	uvec freq_count(num_nodes, fill::zeros);
		for (uword i=0; i < first_nbrs.n_elem; i++) {
			uword first_nbr = first_nbrs(i);
			uvec nbrs2 = find((*adj).col(first_nbr));
			freq_count(nbrs2) = freq_count(nbrs2) + 1;
		}
		freq_count(first_nbrs).fill(limit);
		freq_count(seed) = limit;
		uvec seed_comm = find(freq_count >= limit);
	mat mem_mat = repmat(linspace<rowvec>(0, 1, 2),num_nodes,1);
	mem_mat(seed_comm,zeros<uvec>(1)).fill(1);
	mem_mat(seed_comm,ones<uvec>(1)).fill(0);
	int count = flags.n_elem;
	//previously clustered values: column_0 = 0; column_1 = 2
	for (int i=0;i<=flags.n_elem;i++){
		if(flags(i) != 0){
			/*mem_mat(seed_comm,zeros<uvec>(1)).fill(0);
			mem_mat(seed_comm,ones<uvec>(1)).fill(1);*/
			mem_mat.col(0)(i) = 0;
			mem_mat.col(1)(i) = 2;
		}
	}
	return mem_mat;
}
//-----------------------------------reorganize the mem_mat------------------------------------------------------------------------------
void reorganize(mat* sim_mat, mat* mem_mat, int n) {
	uvec comm1 = find((*mem_mat).col(0));
	mat aff_mat = (*sim_mat)*(*mem_mat);
	vec aff_diff = aff_mat.col(0) - aff_mat.col(1);
	uvec tbm = comm1(find(aff_diff(comm1) < 0));
	comm1 = comm1(find(aff_diff(comm1) > 0));
	// remove from seed community
	while (!tbm.is_empty()) {
		vec diff_vals = 2*sum((*sim_mat)(comm1,tbm),1);
		aff_diff(comm1) = aff_diff(comm1) - diff_vals;
		tbm = comm1(find(aff_diff(comm1) < 0));
		comm1 = comm1(find(aff_diff(comm1) > 0));
	}
	// recreate the mem_mat
	(*mem_mat) = repmat(linspace<rowvec>(0, 1, 2),n,1);
	(*mem_mat)(comm1,zeros<uvec>(1)).fill(1); // have to do this trick because mat(uvec,uword) doesn't work
	(*mem_mat)(comm1,ones<uvec>(1)).fill(0);

	aff_mat = (*sim_mat)*(*mem_mat);
	//column_1 == 1 eliminates the previously clustered values since their values = 2
	uvec comm2 = find((*mem_mat).col(1) == 1);
	aff_diff = aff_mat.col(1) - aff_mat.col(0);
	tbm = comm2(find(aff_diff(comm2) < 0));
	comm2 = comm2(find(aff_diff(comm2) > 0));
	// add to seed community
	while (!tbm.is_empty()) {
		vec diff_vals = 2*sum((*sim_mat)(comm2,tbm),1);
		aff_diff(comm2) = aff_diff(comm2) - diff_vals;
		tbm = comm2(find(aff_diff(comm2) < 0));
		comm2 = comm2(find(aff_diff(comm2) > 0));
	}
	// recreate the mem_mat
	(*mem_mat) = repmat(linspace<rowvec>(1, 0, 2),n,1);
	(*mem_mat)(comm2,ones<uvec>(1)).fill(1);
	(*mem_mat)(comm2,zeros<uvec>(1)).fill(0);
}
//-----------------------------------------------------main---------------------------------------------------------------------------
int main(int argc, char** argv) {
	
	// reading the input
	wall_clock timer;
	string comm_filename;
	timer.tic();
	if(argc < 2) {

		printf("%s\n", "Too few parameters");
		printf("%s%s%s\n", "Usage: ",argv[0]," input_file_name [output_file_name]");
		return 1;
	}
	else if(argc == 3) {
		comm_filename = argv[2];
	}
	else {
		comm_filename = "peel.csv";
	}

	string graph_filename = argv[1];
	ifstream ifile(graph_filename.c_str());
	int num_nodes;
	char buff[256];
	char temp[50];
	ifile.getline(buff, 255);
	sscanf(buff, "%s %d", temp, &num_nodes);

	// hyper-parameters
	double weight = 4;
	uword limit = 3;

	// constructing graph data structures
	mat adj(num_nodes, num_nodes, fill::zeros);
	vec deg(num_nodes, fill::zeros);
	readPajek(ifile, num_nodes, &adj, &deg);
	vec flags(num_nodes, fill::zeros);

	// creating nbr_mat
	sp_mat sp_adj(adj);
	mat adj2(sp_adj*sp_adj);
	mat deg_rows = repmat(deg,1,num_nodes);
	mat deg_mat = deg_rows + trans(deg_rows);
	mat nbr_mat = weight*adj + (adj2/deg_mat);

	// clustering process begins
	int k = 1;
	uvec residual = linspace<uvec>(0,num_nodes-1,num_nodes);
	uvec residual_2 = linspace<uvec>(0,num_nodes-1,num_nodes);	
	
	// if any flag(i) = 0, all nodes have not yet been clustered 
	bool status = any(flags == 0);
	while(status == true){
		// cluster again after peeling has taken place
		uvec flag_count = find(flags);
		uvec flag_count_zero = find(flags == 0);
		int temp_count = flag_count.n_elem;
		uword num_left = flag_count_zero.n_elem;

		vec sort_norm_deg = sort(deg)/sum(deg);
		uvec sort_order = sort_index(deg);

		// --set the row,col value of subadj, sim_mat=0
		//mat subadj = adj(residual,residual);		
		//mat sim_mat = nbr_mat(residual,residual);
		for (int i = 0; i <= temp_count; i++){
			adj.row(flag_count(i)) = 0;
			adj.col(flag_count(i)) = 0;
			nbr_mat.row(flag_count(i)) = 0;
			nbr_mat.col(flag_count(i)) = 0;
		}		
				
		bool found = false;
		uvec comm1;
		uvec comm2;
		for (uword v=0; v < temp_count; v++) {

			// find the seed community and form initial mem_mat
			double rand_num = randu();

			//check the condition if row/ column = 0 before picking up the seed (I think the cumsum takes care of it)
			uvec seed_pos = find(rand_num < cumsum(sort_norm_deg),1,"first");
			uword seed = sort_order(seed_pos(0));
			mat mem_mat = nbr_seed_selection(&adj,seed,num_nodes,limit, flags);

			// reorganize the community structure
			reorganize(&nbr_mat, &mem_mat, num_nodes);
			comm1 = residual(find(mem_mat.col(0)));
			comm2 = residual(find(mem_mat.col(1)));

			// do the peeling
			if ((comm1.n_elem != 0) && (comm2.n_elem != 0)) {
				found = true;
				break;
			}
		}
		if (!found) {
			residual_2 = find(flags == 0);
		}
		else{
			if(comm1.n_elem < comm2.n_elem)
				residual_2 = comm1;
			else
				residual_2 = comm2;
		}

		/* -- setting the degree of the picked nodes = 0
		-- setting the flag value = cluster_number i.e. = k*/
		for (int i=0; i < residual_2.n_elem; i++){
			flags(residual_2(i)) = k;
			deg(residual_2(i)) = 0;
		}
		/* we don't need the residual as a reduced vector
		--If the size of residual does not decrease, then size of adj and nbr_mat doesn't reduce. Thus, size of mem_mat doesn't 			reduce*/
		k++;
		status = any(flags == 0);
	}
	// clustering process end

	// write communities to the output file
	ofstream file(comm_filename.c_str());
	if(!file.is_open())
		return 1;
	for(int i = 0; i < num_nodes; ++i)
		file << flags(i) << endl;
	file.close();
	double n = timer.toc();
	cout<<"number of seconds: "<<n<<endl;	
	return 0;
}
