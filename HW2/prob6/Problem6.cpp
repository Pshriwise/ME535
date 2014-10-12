

#include <fstream>
#include <iostream>
#include <assert.h>
#include <armadillo>
#include <math.h>
#include "formatting.hpp"
#include "BSpline_algs.hpp"

#define _USE_MATH_DEFINES 

using namespace arma;


int main( int argc, char** argv)
{



  //setup knot vector
  double k [] = { 0, 0, 1, 1, 2, 2, 3, 3,};
  std::vector<double> knots( k, k+ (sizeof(k)/sizeof(k[0]) ) );


  double corner_w = cos(M_PI/3); 

  double w [] = { 1, corner_w, 1, corner_w, 1, corner_w, 1};
  Mat<double> CPs;
  
  CPs << cos(M_PI/6)  << sin(M_PI/6) << 0 << endr //0
      << 0            << 2           << 0 << endr //1
      << -cos(M_PI/6) << sin(M_PI/6) << 0 << endr //2
      << -sqrt(3)     << -1          << 0 << endr //3
      << 0            << -1          << 0 << endr //4
      << sqrt(3)      << -1          << 0 << endr //5
      << cos(M_PI/6)    << sin(M_PI/6) << 0 << endr; //6


  std::ofstream CPfile; 
  CPfile.open("CP.dat");
  CPfile << CPs;
  CPfile.close();


  //apply weights
  for (unsigned int i= 0; i < CPs.n_rows; i++)
    {
      CPs.row(i) = w[i]*CPs.row(i);
      CPs(i, (CPs.n_cols-1) ) = w[i];

    }

  CPs=CPs.t();
  



  Mat<double> pnt;
  
  int degree = 2;
  double start = knots[degree-1];
  double end = knots[knots.size() - degree];

  std::ofstream datafile;
  datafile.open("BSpline.dat");
  

  for( double u = start; u <= end; u+=(end-start)/100 )
    {
  
      blossom_de_boor( degree, CPs, knots, u, pnt);
      datafile << pnt(0)/pnt(2) << "\t" << pnt(1)/pnt(2) <<  "\t" << pnt(2) << std::endl; 
    }

  datafile.close();

  part_header("B");
  
  double t = 1;

  std::cout << "The point of the B-Spline at t= " << t << ":" << std::endl; 

  blossom_de_boor(degree, CPs, knots, t, pnt);

  std::cout << pnt << std::endl; 


  //create a circle for comparison

  std::ofstream testdata;
  testdata.open("Unit_Circ.dat");


  for(double theta = 0; theta <= 2*M_PI; theta+= (2*M_PI)/15 )
    {
      
      testdata << cos(theta) << "\t" << sin(theta) << "\t" << std::endl;


    }


  return 0;

}


 
