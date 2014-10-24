

#include <fstream>
#include <iostream>
#include <assert.h>
#include <math.h>
#include <armadillo>
#include "formatting.hpp"
#include "BSpline_algs.hpp"

using namespace arma;


int main( int argc, char** argv)
{

  //setup knot vector
  double ku [] = { 0, 0, 1, 1 };
  std::vector<double> knots_u( ku, ku+ (sizeof(ku)/sizeof(ku[0]) ) );

  double kv [] = { 0, 1 };
  std::vector<double> knots_v( kv, kv+ (sizeof(kv)/sizeof(kv[0]) ) );

  double w [] = { 1, cos(M_PI/4), 1 };
  std::vector<double> weights( w, w + (sizeof(w)/sizeof(w[0]) ) );

  field<vec> CPS(2,3);
  // enter CPs in respective groups for v
  CPS(0,0) << 1 << 0 << 0 << 1;
  CPS(0,1) << 1 << 1 << 0 << 1;
  CPS(0,2) << 0 << 1 << 0 << 1;

  CPS(1,0) << 1 << 0 << 1 << 1;
  CPS(1,1) << 1 << 1 << 1 << 1;
  CPS(1,2) << 0 << 1 << 1 << 1;

  std::cout << CPS << std::endl; 

  //apply weights

  for( unsigned int i = 0; i < weights.size(); i++) 
    {
      CPS(0,i) *= weights[i];
      CPS(1,i) *= weights[i];
    }

  std::cout << CPS << std::endl; 

  std::cout << CPS(0,0).size() << std::endl; 

  Mat<double> pnt;
  
  int u_deg = 2;
  int v_deg = 1;

  Mat<double> Surf(0,0);
  for( double u = 0 ; u <=1 ; u+=0.01)
    for( double v = 0 ; v<=1 ; v+=0.01)
      {
	{
	  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, u, v, pnt, PNT);
	  //remove weight
	  pnt.col(0) = pnt.col(0)/pnt(3);
	  Surf.insert_cols(Surf.n_cols,pnt.col(0));
	}
      }
  //std::cout << pnt << std::endl; 


  std::ofstream datafile; 
  datafile.open("data.dat");

  datafile << Surf.t();

  datafile.close();

  return 0;

}


 
