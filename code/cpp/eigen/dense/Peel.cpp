#include <string>
#include <eigen3/Eigen/Dense>
#include <eigen3/Eigen/Sparse>
#include <fstream>
#include <iostream>

using std::ifstream;
using std::ofstream;
using std::string;
using std::cout;

// this function is used to read the graph from pajek files
void readPajek(const std::string& fname, Eigen::SparseMatrix<double>* adj, Eigen::VectorXd* deg)
{
	//printf("%s\n", "Starting to read file");
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
				(*adj).insert(s-1,d-1) = w;
				(*adj).insert(d-1,s-1) = w;
				(*deg)(s-1)++;
				(*deg)(d-1)++;
			}
		}
	}
	file.close();
	printf("%s\n", "Finished reading file");
}

int main(int argc, char** argv) {
	if(argc != 3) {
		printf("%s\n", "Very few parameters");
		return 1;
	}

	string graph_filename = argv[1];
	int num_nodes = atoi(argv[2]);

	// form the data structures
	Eigen::SparseMatrix<double> adj(num_nodes,num_nodes);
	Eigen::VectorXd deg(num_nodes);
	readPajek(graph_filename, &adj, &deg);

	// get the nbr_sim matrix
	Eigen::SparseMatrix<double> adj_sq = adj*adj;
	Eigen::MatrixXd full_adj_sq = Eigen::MatrixXd(adj_sq);
	Eigen::MatrixXd deg_row = deg.replicate(1,num_nodes);
	Eigen::MatrixXd deg_col = deg.transpose().replicate(num_nodes,1);
	Eigen::MatrixXd deg_mat = deg_row + deg_col;
	Eigen::MatrixXd nbr_sim = full_adj_sq.cwiseQuotient(deg_mat) + Eigen::MatrixXd(adj);
}