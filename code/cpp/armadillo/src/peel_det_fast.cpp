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

// this function is used to read the graph from pajek files
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

// find the seed set given a seed
mat nbr_seed_selection(mat *adj, uword seed, uword num_nodes, uword limit) {
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
	mem_mat(seed_comm,zeros<uvec>(1)) = ones<vec>(seed_comm.n_elem);
	mem_mat(seed_comm,ones<uvec>(1)) = zeros<vec>(seed_comm.n_elem);
	return mem_mat;
}

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
	(*mem_mat)(comm1,zeros<uvec>(1)) = ones<vec>(comm1.n_elem); // have to do this trick because mat(uvec,uword) doesn't work
	(*mem_mat)(comm1,ones<uvec>(1)) = zeros<vec>(comm1.n_elem);

	aff_mat = (*sim_mat)*(*mem_mat);
	uvec comm2 = find((*mem_mat).col(1));
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
	(*mem_mat)(comm2,ones<uvec>(1)) = ones<vec>(comm2.n_elem);
	(*mem_mat)(comm2,zeros<uvec>(1)) = zeros<vec>(comm2.n_elem);
}

int main(int argc, char** argv) {
	
	// reading the input
	string comm_filename;
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
	double weight = 5;
	uword limit = 4;

	// constructing graph data structures
	mat adj(num_nodes, num_nodes, fill::zeros);
	vec deg(num_nodes, fill::zeros);
	readPajek(ifile, num_nodes, &adj, &deg);

	// creating nbr_mat
	sp_mat sp_adj(adj);
	mat adj2(sp_adj*sp_adj);
	mat deg_rows = repmat(deg,1,num_nodes);
	mat deg_mat = deg_rows + trans(deg_rows);
	mat nbr_mat = weight*adj + (adj2/deg_mat);

	// clustering process begins
	uvec clustering(num_nodes,fill::zeros);
	int k = 1;
	uvec residual = linspace<uvec>(0,num_nodes-1,num_nodes);
	while(!residual.is_empty()) {

		// cluster again after peeling has taken place
		uword num_left = residual.n_elem;
		vec res_deg = deg(residual);
		mat sim_mat = nbr_mat(residual,residual);
		mat subadj = adj(residual,residual);

		// find the seed community and form initial mem_mat
		uword seed;
		double seed_deg = res_deg.max(seed);
		mat mem_mat = nbr_seed_selection(&subadj,seed,num_left,limit);

		// reorganize the community structure
		reorganize(&sim_mat, &mem_mat, num_left);
		uvec comm1 = residual(find(mem_mat.col(0)));
		uvec comm2 = residual(find(mem_mat.col(1)));

		// do the peeling
		if ((comm1.n_elem == 0) || (comm2.n_elem == 0)) {
			clustering(residual).fill(k);
			break;
		}
		else {
			if (comm1.n_elem < comm2.n_elem) {
				residual = comm2;
				clustering(comm1).fill(k);
			}
			else {
				residual = comm1;
				clustering(comm2).fill(k);
			}
		}	
		k++;
	}
	// clustering process end
	// write communities to the output file
	ofstream file(comm_filename.c_str());
	if(!file.is_open())
		return 1;
	for(int i = 0; i < num_nodes; ++i)
		file << clustering(i) << endl;
	file.close();
	
	return 0;
}