
#include <math.h>
#include <armadillo>
#include "Ferguson.hpp"

using namespace arma; 

Row<double> ferg_surf( field<vec> cps, double u, double v) 
{

  //setup parameter values

  Mat<double> u_vec;
  u_vec << pow(u,3) << pow(u,2) << u << 1 << endr; 
  Mat<double> v_vec;
  v_vec << pow(v,3) << pow(v,2) << v << 1 << endr;   
  v_vec = v_vec.t();
  
  // now setup the coefficients for the basis matrix
  double b[16]   =  {  2, -2,  1,  1,
		      -3,  3, -2, -1,
		       0,  0,  1,  0,
		       1,  0,  0,  0};

        
  Mat<double> B(b,4,4,false);
  B = B.t();

  Mat<double> X(4,4),Y(4,4),Z(4,4),W(4,4);
  for(unsigned int i = 0; i < cps.n_rows; i++)
    for(unsigned int j = 0; j < cps.n_cols; j++)
      {{
	  X(i,j) = cps(i,j)(0);
	  Y(i,j) = cps(i,j)(1);
	  Z(i,j) = cps(i,j)(2);
	}}
  
  Mat<double> temp,pnt;
  pnt.resize(cps(0,0).n_rows,1);

  temp = u_vec*B*X*B.t()*v_vec; pnt(0,0) = temp(0,0); 
  temp = u_vec*B*Y*B.t()*v_vec; pnt(1,0) = temp(0,0); 
  temp = u_vec*B*Z*B.t()*v_vec; pnt(2,0) = temp(0,0);

  return pnt.t();

}
