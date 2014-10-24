
#include <armadillo>
#include <math.h> 
#include <assert.h>
#include "Coons.hpp"

using namespace arma; 

//returns points for a coons patch at parametric values of u & v
Row<double> coons_value( std::vector< Row<double>(*)(double) > curve_funcs, double u, double v) 
{

  Row<double> Lc,Ld,B;

  Row<double>(*c0)(double) = curve_funcs[0]; 
  Row<double>(*d0)(double) = curve_funcs[1];
  Row<double>(*c1)(double) = curve_funcs[2]; 
  Row<double>(*d1)(double) = curve_funcs[3]; 

  Lc = (1-v)*(c0(u)) + v*(c1(u));

  Ld = (1-u)*(d0(v)) + u*(d1(v)); 

  B = c0(0)*(1-u)*(1-v) + c0(1)*u*(1-v) + c1(0)*(1-u)*v + c1(1)*u*v;

  return Lc+Ld-B;

}
