
#include <armadillo> 
#include <assert.h>

using namespace arma;

enum surf_calc { PNT, DERIV_U, DERIV_V, DERIV_UV };

void surf_de_boor( int degree_u, int degree_v, field<vec> cps, std::vector<double> knots_u, std::vector<double> knots_v, double u, double v, Mat<double> &value, int calc_type, bool nurbs=false );

void setup_params( int degree, Mat<double> cps, std::vector<double> knots, double u, Mat<double> &base, std::vector<double> &sub_knots );

void blossom_de_boor( int degree, Mat<double> cps, std::vector<double> knots, double u, Mat<double> &pnt, bool deriv = false);

void find_pnts( Mat<double> base, std::vector<double> &knots, Mat<double> &pnt, double u, int num_pnts );



