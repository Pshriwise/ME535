

#include <fstream>
#include <iostream>
#include <assert.h>
#include <armadillo>
#include "formatting.hpp"
#include "BSpline_algs.hpp"

using namespace arma;

void find_x_pnts( double y, Mat<double> pnts, std::vector<double> &xs );


bool dbl_comp( double a, double b, double delta)
{
  return fabs(b-a) < delta;
}


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
  Mat<double>curve_pnts;
  int i = 0;
  for( double u = start; u <= end; u+=(end-start)/1000 )
    {

      blossom_de_boor( degree, CPs, knots, u, pnt);
      datafile << pnt(0) << "\t" << pnt(1) <<  "\t" << pnt(2) << std::endl; 
      curve_pnts = join_rows(curve_pnts, pnt);

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


  //now create the boxes as needed
  std::vector<double> x_pnts;
  Mat<double> box;

  std::ofstream boxfile; 
  boxfile.open("boxes.dat");

  double this_y = y_max - thickness;
  double prev_y = y_max;
  while( this_y >= y_min)
    {

      //find all x points for this y value
      find_x_pnts( this_y, curve_pnts, x_pnts);

      assert( 2 == x_pnts.size() );

      //create our box
      box << x_pnts[0] << this_y << endr
	  << x_pnts[0] << this_y+thickness << endr
	  << x_pnts[1] << this_y+thickness << endr
	  << x_pnts[1] << this_y << endr; 

      //box.insert_rows(box.n_rows-1, box.row(0));
      
      boxfile << box << std::endl; 

      box.clear();
      x_pnts.clear();
  
      prev_y = this_y; 
      this_y -= thickness; 
      
    }

  //make one more box to wrap it up 

  assert( prev_y - y_min < thickness);

  this_y = (prev_y+y_min)/2;


  find_x_pnts( this_y, curve_pnts, x_pnts);

  assert( 2 == x_pnts.size() );
  
  //create our box
  box << x_pnts[0] << y_min << endr
      << x_pnts[0] << prev_y << endr
      << x_pnts[1] << prev_y << endr
      << x_pnts[1] << y_min << endr; 

  boxfile << box << std::endl; 

  
  boxfile.close();

  return 0;


}


void find_x_pnts( double y, Mat<double> pnts, std::vector<double> &xs )
{

  //loop through curve points and check for intersections 
  for( unsigned int i = 0; i < pnts.n_cols-1; i++)
    {
      double x; 
      //check for y intersection with this line
      double u = (y-pnts(1,i))/(pnts(1,i+1)-pnts(1,i));
      std::cout << u << std::endl; 
      if( 0 < u && 1 > u ) 
	{
	  //calculate the x point 
	  x = ((pnts(0,i+1)-pnts(0,i))*u) + pnts(0,i);
	  xs.push_back(x);
	}
	  


    }
  
}

