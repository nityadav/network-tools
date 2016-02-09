#include "Graph.h"
#include <fstream>
#include <iostream>

using std::ifstream;
using std::ofstream;
using std::string;
using std::cout;

Graph::Graph(const std::string& fname)
{
	adj = new SpMat(1000,1000);
	readPajek(fname);
	SpMat adj_sq = (*adj)*(*adj);
	hd = adj_sq.cwiseProduct(adj);
}

Graph::~Graph(void)
{
}

void Graph::readPajek(const std::string& fname)
{
	printf("%s\n", "Starting to read file");
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
				adj->insert(s-1,d-1) = w;

			}
		}
	}
	file.close();
	printf("%s\n", "Finished reading file");
}