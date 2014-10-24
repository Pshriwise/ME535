

#include <fstream>
#include <iostream>
#include <assert.h>
#include <math.h>
#include <armadillo>
#include "formatting.hpp"
#include "Coons.hpp"

using namespace arma;

Row<double> cxy( double ll, double ul, double u);
Row<double> cxz( double ll, double ul, double u);


//curve 1
Row<double> c1(double u) { Row<double> dum = cxy(0, 0.5*M_PI, u); return dum; }

//curve 2
Row<double> c2(double u) { Row<double> dum = cxz(0, 0.5*M_PI, u); return dum; } 

//curve 3
Row<double> c3(double u) { Row<double> dum = cxz(0.5*M_PI, M_PI, u); return dum; } 

//curve 4
Row<double> c4(double u) { Row<double> dum = cxy(0.5*M_PI, M_PI, u); return dum; }


int main( int argc, char** argv)
{

 
  std::vector< Row<double>(*)(double) > func_ptrs; 

  func_ptrs.push_back(c1);
  func_ptrs.push_back(c2);   
  func_ptrs.push_back(c3);   
  func_ptrs.push_back(c4); 

  Row<double>test; 
  
  Mat<double>surf(0,0);
  //sweet the parameter space, add to a matrix as we do so
  for(double u = 0; u <= 1; u+=0.01){
    for(double v=0; v <=1 ; v+=0.01){
      surf.insert_rows(surf.n_rows, coons_value( func_ptrs, u, v)); 
    }}


  std::ofstream datafile; 
  datafile.open("data.dat"); 
  
  datafile << surf;

  datafile.close(); 
    
  return 0;

}
 


Row<double> cxy( double ll, double ul, double u)
{

  assert( 0 <= u && 1 >= u ); 

  //setup limits
  double theta = ll+u*(ul-ll); 
  Row<double> val(3); 

  val(0) = cos(theta);
  val(1) = sin(theta); 
  val(2) = 0; 

  return val; 

}


Row<double> cxz( double ll, double ul, double u)
{

  assert( 0 <= u && 1 >= u ); 

  //setup limits
  double theta = ll+u*(ul-ll); 
  Row<double> val(3); 

  val(0) = cos(theta);
  val(1) = 0; 
  val(2) = sin(theta); 


  return val; 

}
  
