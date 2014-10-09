#include <iostream>
#include <fstream>
#include <armadillo>
#include <assert.h>
#include "formatting.hpp"
#include "Bezier_algs.hpp"


using namespace arma;


int main( int argc, char** argv) 
{


  //setup the first bezier curve
  Mat<double> P1;
  P1 << 425 << 210 << 0 << endr
     << 425 << 318.5 << 0 << endr
     << 227 << 329.5 << 0 << endr
     << 227 << 410 << 0 << endr;

  P1=P1.t();

  Mat<double> P2; 
  P2 << 227 << 410 << 0 << endr
     << 227 << 437 << 0 << endr
     << 250 << 463 << 0 << endr
     << 290 << 463 << 0 << endr;

  P2=P2.t();


  Mat<double> P3; 
  P3 << 290 << 463 << 0 << endr
     << 345 << 463 << 0 << endr
     << 383 << 430 << 0 << endr
     << 391 << 358 << 0 << endr;
    
  P3=P3.t();


  //open file to write data to
  std::ofstream datafile;
  datafile.open("S_curves.dat");

  std::ofstream CPfile; 
  CPfile.open("CPs.dat");


  //create data structures for input from de_cast
  Mat<double> pnt;
  std::vector< Mat<double> > plot_dat; 

  //create a vector of CP matrices
  std::vector< Mat<double> > CPs;
  CPs.push_back(P1);
  CPs.push_back(P2);
  CPs.push_back(P3);

  for( std::vector< Mat<double> >::iterator i = CPs.begin();
       i != CPs.end() ; i++)
    {
  
      for(double t = 0; t< 1 ; t+=0.01)    
	{
	  
	  //calculate the point
	  de_cast( t, *i, pnt, plot_dat);
	  
	  //write point value to file 
	  datafile << pnt(0) << "\t" << pnt(1) << "\t" << pnt(2) << std::endl;

	  //write CPS to file 
	  for( unsigned int col = 0; col < (*i).n_cols ; col++)
	    CPfile << (*i)(0,col) << "\t" << (*i)(1,col) << "\t" << (*i)(2,col) << std::endl;
	  
	 }

    }
      

  return 0;

}
