

#include <fstream>
#include <iostream>
#include <assert.h>
#include <armadillo>
#include "formatting.hpp"
#include "BSpline_algs.hpp"

using namespace arma;


int main( int argc, char** argv)
{

  //setup knot vector
  double ku [] = {1, 2, 3, 4, 5};
  std::vector<double> knots_u( ku, ku+ (sizeof(ku)/sizeof(ku[0]) ) );

  double kv [] = {0, 1, 2, 3};
  std::vector<double> knots_v( kv, kv+ (sizeof(kv)/sizeof(kv[0]) ) );


  field<vec> CPS(3,4);
  // enter CPs in respective groups for v
  CPS(0,0) << 0 << 2 << 4;
  CPS(0,1) << 0 << 6 << 4;
  CPS(0,2) << 0 << 8 << 5;
  CPS(0,3) << 0 << 2 << 0;

  CPS(1,0) << 4 << 6 << 8;
  CPS(1,1) << 12 << 24 << 12;
  CPS(1,2) << 8  << 10 << 3;
  CPS(1,3) << 4 << 6 << 0;

  CPS(2,0) << 4 << 2 << 4;
  CPS(2,1) << 8 << 6 << 4;
  CPS(2,2) << 6 << 4 << 2;
  CPS(2,3) << 4 << 2 << 0;


  std::cout << CPS << std::endl; 

  std::cout << CPS(0,0).size() << std::endl; 

  Mat<double> pnt;
  
  int u_deg = 2;
  int v_deg = u_deg;

  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, 2.5, 1.5, pnt);

  std::cout << pnt << std::endl; 

  return 0;

}


 
