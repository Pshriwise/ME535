

#include <fstream>
#include <iostream>
#include <assert.h>
#include <math.h>
#include <armadillo>
#include "formatting.hpp"
#include "BSpline_algs.hpp"
#include "Bezier_algs.hpp"
#include "Coons.hpp"

using namespace arma;

Row<double> c1 (double u);
Row<double> c2 (double u);
Row<double> c3 (double u);
Row<double> c4 (double u);


int main( int argc, char** argv)
{

  part_header("A");

  //setup knot vector
  std::cout << "The knot values in u and v are: " << std::endl;  
  double ku [] = { 0, 0, 0, 1, 2, 3, 4, 4, 4 };
  std::vector<double> knots_u( ku, ku+ (sizeof(ku)/sizeof(ku[0]) ) );
  std::cout << std::endl << "U" << std::endl;
  for(unsigned int i = 0; i < knots_u.size(); i++ )std::cout << knots_u[i] << std::endl; 


  std::vector<double> knots_v= knots_u;
  std::cout << std::endl << "V" << std::endl;  
  for(unsigned int i = 0; i < knots_v.size(); i++ )std::cout << knots_v[i] << std::endl; 

  field<vec> CPS(7,7);
  // enter CPs in respective groups for v
  CPS(0,0) << 0 << 0 << 0 ;
  CPS(0,1) << 0 << 10 << 0;
  CPS(0,2) << 0 << 20 << 5;
  CPS(0,3) << 0 << 30 << 15;
  CPS(0,4) << 0 << 40 << 10;
  CPS(0,5) << 0 << 50 << 5;
  CPS(0,6) << 0 << 60 << 0;

  CPS(1,0) << 10 << 0 << 0;
  CPS(1,1) << 10 << 10 << 10;
  CPS(1,2) << 10 << 20 << 20;
  CPS(1,3) << 10 << 30 << 20;
  CPS(1,4) << 10 << 40 << 30;
  CPS(1,5) << 10 << 50 << 15;
  CPS(1,6) << 10 << 60 << 5;


  CPS(2,0) << 20 << 0 << 0;
  CPS(2,1) << 20 << 10 << 30;
  CPS(2,2) << 20 << 20 << 40;
  CPS(2,3) << 20 << 30 << 35;
  CPS(2,4) << 20 << 40 << 35;
  CPS(2,5) << 20 << 50 << 15;
  CPS(2,6) << 20 << 60 << 10;

  CPS(3,0) << 30 << 0 << 0;
  CPS(3,1) << 30 << 10 << 25;
  CPS(3,2) << 30 << 20 << 45;
  CPS(3,3) << 30 << 30 << 40;
  CPS(3,4) << 30 << 40 << 35;
  CPS(3,5) << 30 << 50 << 25;
  CPS(3,6) << 30 << 60 << 15;

  CPS(4,0) << 40 << 0 << 0;
  CPS(4,1) << 40 << 10 << 15;
  CPS(4,2) << 40 << 20 << 35;
  CPS(4,3) << 40 << 30 << 45;
  CPS(4,4) << 40 << 40 << 50;
  CPS(4,5) << 40 << 50 << 30;
  CPS(4,6) << 40 << 60 << 20;


  CPS(5,0) << 50 << 0 << 0;
  CPS(5,1) << 50 << 10 << 15;
  CPS(5,2) << 50 << 20 << 30;
  CPS(5,3) << 50 << 30 << 35;
  CPS(5,4) << 50 << 40 << 40;
  CPS(5,5) << 50 << 50 << 25;
  CPS(5,6) << 50 << 60 << 15;


  CPS(6,0) << 60 << 0 << 0;
  CPS(6,1) << 60 << 10 << 5;
  CPS(6,2) << 60 << 20 << 15;
  CPS(6,3) << 60 << 30 << 25;
  CPS(6,4) << 60 << 40 << 28;
  CPS(6,5) << 60 << 50 << 15;
  CPS(6,6) << 60 << 60 << 5;

  //std::cout << "The matrix of control points looks like" << std::endl; 
  //std::cout << CPS << std::endl; 

  //std::cout << CPS(0,0).size() << std::endl; 

  Mat<double> pnt;
  
  int u_deg = 3;
  int v_deg = 3;

  std::cout << "Value of point at u = 2.5, v = 1.5:" << std::endl; 
  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, 2.5, 1.5, pnt, PNT);
  std::cout << pnt << std::endl; 


  std::cout << "Value of derivative in u at u = 2.5, v = 1.5:" << std::endl; 
  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, 2.5, 1.5, pnt, DERIV_U);
  std::cout << pnt << std::endl; 

  std::cout << "Value of derivative in v at u = 2.5, v = 1.5:" << std::endl; 
  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, 2.5, 1.5, pnt, DERIV_V);
  std::cout << pnt << std::endl; 

  Mat<double> Surf(0,0);
  for( double u = 0 ; u <=4 ; u+=0.05)
    for( double v = 0 ; v<=4 ; v+=0.05)
      {
	{
	  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, u, v, pnt, PNT);
	  Surf.insert_cols(Surf.n_cols,pnt.col(0));
	}
      }


  std::ofstream datafile; 
  datafile.open("data.dat");

  datafile << Surf.t();

  datafile.close();

  return 0; 

}
