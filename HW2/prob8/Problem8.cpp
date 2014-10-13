

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
  double k [] = { 0, 0, 0, 1, 2, 3, 4, 5, 6, 6, 6};
  std::vector<double> knots( k, k+ (sizeof(k)/sizeof(k[0]) ) );


  Mat<double> CPs;
  
  CPs << 10  << 15 << 20  << endr
      << 20  << 25 << 5   << endr
      << 40  << 25 << 0   << endr
      << 60  << 5  << 0   << endr
      << 80  << 15 << -5  << endr
      << 80  << 30 << -10 << endr
      << 90  << 45 << -10 << endr
      << 115 << 40 << -5  << endr
      << 125 << 15 << 0   << endr; 


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
  
  double t = 1.5;

  std::cout << "The point of the B-Spline at t= " << t << ":" << std::endl; 

  blossom_de_boor(degree, CPs, knots, t, pnt);

  std::cout << pnt << std::endl; 

  return 0;

}


 
