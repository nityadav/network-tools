#include <string>
#include <eigen3/Eigen/Sparse>

typedef Eigen::SparseMatrix<double> SpMat;

class Graph
{
public:
	Graph(const std::string& fname);
	virtual ~Graph(void);
	void readPajek(const std::string& fname);

private:
	int num_nodes;
	SpMat *adj;
};