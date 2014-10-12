
#include <armadillo> 
#include <assert.h>

using namespace arma;

void blossom_de_boor( int degree, Mat<double> cps, std::vector<double> knots, double u, Mat<double> &pnt, bool deriv = false);

void find_pnt( Mat<double> base, std::vector<double> knots, Mat<double> &pnt, double u );


void find_slope( Mat<double> base, std::vector<double> knots, Mat<double> &deriv, double u);
