
#include <armadillo>
#include <math.h> 
#include <assert.h>


using namespace arma; 

//returns points for a coons patch at parametric values of u & v
// assumed curve orientation: c0(0) = d0(0), c0(1) = d1(0), c1(0) = d0(1), c1(1) = d1(1)
Row<double> coons_value( std::vector< Row<double>(*)(double) > curve_funcs, double u, double v);
