#include <iostream>
#include <fstream>
#include <armadillo>
#include <assert.h>
#include "formatting.hpp"
#include "Bezier_algs.hpp"


using namespace arma;


int main( int argc, char** argv) 
{


  Mat<double>new_pnts;


  //setup the first bezier curve
  Mat<double> C1;
  
  new_pnts << 425 << 210 << 0 << endr
           << 425 << 318.5 << 0 << endr
           << 227 << 329.5 << 0 << endr
           << 227 << 410 << 0 << endr;

  C1 = new_pnts; 


  Mat<double> C2; 

  //keep the last point from P1
  C2.insert_rows( 0, C1.row(3) );

  new_pnts.clear();
  new_pnts << 227 << 437 << 0 << endr
           << 250 << 463 << 0 << endr
	   << 290 << 463 << 0 << endr;
  
  //join the new and old
  C2 = join_cols(C2, new_pnts);


  Mat<double> C3; 
  C3.insert_rows(0, C2.row(3) );

  new_pnts << 345 << 463 << 0 << endr
           << 383 << 430 << 0 << endr
           << 391 << 360 << 0 << endr;

  C3 = join_cols(C3, new_pnts);
    
  Mat<double> C4;

  C4.insert_rows(0, C3.row(3) );
  C4.insert_rows(1, C3.row(3) );
  C4.insert_rows(2, C3.row(3) );

  new_pnts << 402 << 360 << 0 << endr; 

  C4 = join_cols(C4, new_pnts);

  Mat<double> C5; 
  C5.insert_rows(0, C4.row(3) );
  C5.insert_rows(1, C4.row(3) );
  C5.insert_rows(2, C4.row(3) );

  new_pnts << 402 << 485 << 0 << endr; 

  C5 = join_cols(C5, new_pnts);


  Mat<double> C6; 

  C6.insert_rows(0, C5.row(3) );
  C6.insert_rows(1, C5.row(3) );
  C6.insert_rows(2, C5.row(3) );
  
  new_pnts << 390.5 << 485 << 0 << endr;

  C6= join_cols(C6, new_pnts); 

  Mat<double> C7;

  C7.insert_rows(0, C6.row(3) );

  new_pnts << 382 << 437 << 0 << endr
           << 350 << 486 << 0 << endr
	   << 289 << 486 << 0 << endr;
  
  C7 = join_cols(C7, new_pnts);
  

  Mat<double> C8;

  C8.insert_rows(0, C7.row(3));

  new_pnts << 230 << 485 << 0 << endr
           << 183.2 << 444 << 0 << endr
           << 183.5 << 390.2 << 0 << endr;

  C8= join_cols(C8, new_pnts);
  
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
  CPs.push_back( C1.t() );
  CPs.push_back( C2.t() );
  CPs.push_back( C3.t() );
  CPs.push_back( C4.t() );
  CPs.push_back( C5.t() );
  CPs.push_back( C6.t() );
  CPs.push_back( C7.t() );
  CPs.push_back( C8.t() );

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
