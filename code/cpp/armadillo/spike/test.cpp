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

int main(int argc, char** argv) {
	mat m(5,5,fill::zeros);
	uvec v;
	v << 1 << 2 << 3;
	m(v,zeros<uvec>(1)).fill(1);
	cout << m;
}