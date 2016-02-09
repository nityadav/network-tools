#define ARMA_NO_DEBUG

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
void readPajek(const std::string& fname, int num_nodes, mat* adj, uvec* deg) {
	ifstream file(fname.c_str());
	if(!file.is_open())
		return;
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
umat nbr_seed_selection(mat adj, uword seed, uword num_nodes, uword limit) {
	uvec first_nbrs = find(adj.col(seed));
	uvec freq_count(num_nodes, fill::zeros);
	for (uword i=0; i < first_nbrs.n_elem; i++) {
		uword first_nbr = first_nbrs(i);
		uvec nbrs2 = find(adj.row(first_nbr));
		freq_count(nbrs2) = freq_count(nbrs2) + 1;
	}
	freq_count(first_nbrs).fill(limit);
	freq_count(seed) = limit;
	umat mem_mat(num_nodes,2,fill::zeros);
	uvec seed_comm = freq_count >= limit;
	uvec non_seed_comm = freq_count < limit; // TBO
	mem_mat.col(0) = seed_comm;
	mem_mat.col(1) = non_seed_comm;
	return mem_mat;
}

void reorganize(mat sim_mat, umat* mem_mat, int n) {
	// remove from seed community
	do {
		mat aff_mat = sim_mat*(*mem_mat);
		uvec truth = aff_mat.col(0) > aff_mat.col(1);
		uvec tbr = find(((*mem_mat).col(0) - truth) == 1);
		if (tbr.is_empty()) break;
		(*mem_mat).elem(tbr) = zeros<uvec>(tbr.n_elem);
		(*mem_mat).elem(tbr + n) = ones<uvec>(tbr.n_elem);
	} while (true);
	// add to seed community
	do {
		mat aff_mat = sim_mat*(*mem_mat);
		uvec truth = aff_mat.col(0) < aff_mat.col(1);
		uvec tba = find(((*mem_mat).col(1) - truth) == 1);
		if (tba.is_empty()) break;
		(*mem_mat).elem(tba) = ones<uvec>(tba.n_elem);
		(*mem_mat).elem(tba + n) = zeros<uvec>(tba.n_elem);
	} while (true);
}

void peel_away(uvec* verts, mat* A, mat* N, uvec* D) {
	uword n = (*verts).n_elem;
	//cout << (*verts);
	for (int i = n; i >= 0; i--) {
		uword v = (*verts)(i);
		(*A).shed_row(v);
		(*A).shed_col(v);
		(*N).shed_row(v);
		(*N).shed_col(v);
		(*D).shed_row(v);
	}
}

int main(int argc, char** argv) {

	// reading the input
	if(argc != 3) {
		printf("%s\n", "Too few parameters");
		return 1;
	}
	string graph_filename = argv[1];
	int num_nodes = atoi(argv[2]);

	// to record time taken by different blocks
	wall_clock timer;
	vec clock(6,fill::zeros);

	timer.tic();
	// constructing graph data structures
	mat adj(num_nodes, num_nodes);
	uvec deg(num_nodes, fill::zeros);
	readPajek(graph_filename, num_nodes, &adj, &deg);
	clock(0) += timer.toc();

	timer.tic();
	// creating nbr_mat
	sp_mat sp_adj(adj);
	sp_mat sp_adj2 = sp_adj*sp_adj;
	mat adj2(sp_adj2);
	umat deg_mat = repmat(deg,1,num_nodes) + repmat(trans(deg),num_nodes,1);
	mat nbr_mat = adj + (adj2/deg_mat);
	clock(1) += timer.toc();

	// clustering process begins
	uvec clustering(num_nodes,fill::zeros);
	int k = 1;
	uvec true_index = linspace<uvec>(0,num_nodes-1,num_nodes);
	while(num_nodes > 0) {

		timer.tic();
		// find the seed community and form initial mem_mat
		uword seed;
		uword seed_deg = deg.max(seed);
		umat mem_mat = nbr_seed_selection(adj,seed,num_nodes,3);
		clock(3) += timer.toc();

		timer.tic();
		// reorganize the community structure
		reorganize(nbr_mat, &mem_mat, num_nodes);
		uvec comm1 = find(mem_mat.col(0));
		uvec comm2 = find(mem_mat.col(1));
		clock(4) += timer.toc();

		timer.tic();
		// do the peeling
		int n1 = comm1.n_elem;
		int n2 = comm2.n_elem;
		if ((n1 == 0) || (n2 == 0)) {
			clustering(true_index).fill(k);
			num_nodes = 0;
			break;
		}
		else {
			if (n1 < n2) {
				num_nodes -= n1;
				for (int i = n1-1; i >=0; i--) {
					uword v = comm1(i);
					adj.shed_row(v);
					adj.shed_col(v);
					nbr_mat.shed_row(v);
					nbr_mat.shed_col(v);
					deg.shed_row(v);
				}
			}
			else {
				num_nodes -= n2;
				for (int i = n2-1; i >=0; i--) {
					uword v = comm2(i);
					adj.shed_row(v);
					adj.shed_col(v);
					nbr_mat.shed_row(v);
					nbr_mat.shed_col(v);
					deg.shed_row(v);
				}
			}
		}	
		k++;
		clock(5) += timer.toc();
	}
	// clustering process end
	//cout << clustering;
	cout << clock << '\n';
	cout << "Total time taken: " << sum(clock) << '\n';
	cout << "k: " << k << '\n';
	return 0;
}