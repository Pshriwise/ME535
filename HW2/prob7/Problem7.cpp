

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
  double k [] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  std::vector<double> knots( k, k+ (sizeof(k)/sizeof(k[0]) ) );


  Mat<double> CPs;
  
  CPs << 0   << 0  << 0 << endr
      << 0   << 4  << 0 << endr
      << 1.5 << 6  << 0 << endr
      << 3   << 4  << 0 << endr
      << 3   << 0  << 0 << endr
      << 1.5 << -2 << 0 << endr
      << 0   << 0  << 0 << endr
      << 0   << 4  << 0 << endr 
      << 1.5 << 6  << 0 << endr;


  CPs=CPs.t();
  

  Mat<double> pnt;
  
  int degree = 3;
  double start = knots[degree-1];
  double end = knots[knots.size()-(degree)];

  std::ofstream datafile;
  datafile.open("BSpline.dat");
  
  double y_max, y_min;
  bool first = true;

  for( double u = start; u <= end; u+=(end-start)/1000 )
    {

      blossom_de_boor( degree, CPs, knots, u, pnt);
      datafile << pnt(0) << "\t" << pnt(1) <<  "\t" << pnt(2) << std::endl; 


      //check for new y_max
      if( first || pnt(1) > y_max ) y_max = pnt(1);
      //check for new y_min
      if( first || pnt(1) < y_min ) y_min = pnt(1);

      first = false;
    }

  datafile.close();
  std::ofstream CPfile; 
  CPfile.open("CP.dat");
  CPfile << CPs.t();
  CPfile.close();

  //calculate the number of layers needed 
  double thickness = 0.1;
  int layers = ceil((y_max-y_min)/thickness);

  std::cout << "The number of layers required to make this part is: " << layers << std::endl; 





  return 0;

}


 
