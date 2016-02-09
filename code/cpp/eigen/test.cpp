#include <eigen3/Eigen/Sparse>
#include <string>
#include <cstdio>

using std::string;
typedef Eigen::SparseMatrix<double> SpMat;

int main(int argc, char** argv) {

	SpMat k(10,10);

	string s = "*Vertices 1000";
	int t = 0;
	char r[20];
	sscanf(s.c_str(),"%s %d",r,&t);
	printf("%d", t);
}
