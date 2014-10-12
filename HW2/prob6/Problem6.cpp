

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
  double k [] = { -2, -1, 0, 2, 4, 5, 6, 6};
  std::vector<double> knots( k, k+ (sizeof(k)/sizeof(k[0]) ) );


  Mat<double> CPs;
  
  CPs << 0 << 0 << 0 << endr
      << 1 << 0 << 0 << endr
      << 1 << 1 << 0 << endr
      << 0 << 1 << 0 << endr
      << 0 << 2 << 0 << endr
      << 2 << 2 << 0 << endr;


  CPs=CPs.t();
  

  Mat<double> pnt;
  
  int degree = 3;
  double start = knots[degree-1];
  double end = knots[knots.size()-(degree)];

  std::ofstream datafile;
  datafile.open("BSpline.dat");
  
 
  for( double u = start; u <= end; u+=(end-start)/100 )
    {
      blossom_de_boor( degree, CPs, knots, u, pnt);
      datafile << pnt(0) << "\t" << pnt(1) <<  "\t" << pnt(2) << std::endl; 
    }

  datafile.close();
  std::ofstream CPfile; 
  CPfile.open("CP.dat");
  CPfile << CPs.t();
  CPfile.close();

  part_header("B");
  
  double t = 3;

  std::cout << "The point of the B-Spline at t= " << t << ":" << std::endl; 

  blossom_de_boor(degree, CPs, knots, t, pnt);

  std::cout << pnt << std::endl; 

  std::cout << "The derivative of the B-Spline at t= " << t << ":" << std::endl; 

  blossom_de_boor(degree, CPs, knots, t, pnt, true);

  std::cout << pnt << std::endl; 


  return 0;

}


 
