#include <string>
#include <eigen3/Eigen/Dense>

class Graph
{
public:
	Graph(const std::string& fname);
	virtual ~Graph(void);
	void readPajek(const std::string& fname);

private:
	int num_nodes;
	 *adj;
};