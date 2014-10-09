#include <iostream>
#include <fstream>
#include <armadillo>
#include <assert.h>
#include "formatting.hpp"

using namespace arma;


void de_cast( double u, Mat<double> CP, Mat<double> &pnt, std::vector<Mat<double > > &plot_data );

void de_cast_prime( double u, double order, Mat<double> CP, Mat<double> &value, std::vector<Mat<double > > &plot_data );


int main( int argc, char** argv) 
{


  //Part A 
  part_header("A");
  //get the derivative of the curve at this point
  double u = 0.5; 

  //define the control point matrix
  Mat<double> P;
  P << 0 << 0 << 0 << endr
    << 1 << 2 << 0 << endr
    << 3 << 5 << 0 << endr
    << 4 << 4 << 0 << endr;

  //transpose P to get the format correct
  P = P.t();

  Mat<double> derivative;
  std::vector< Mat<double> > plot_dat;
  de_cast_prime( u, (P.n_cols-1),  P, derivative, plot_dat);

  std::cout << "The derivative of the curve at u=" << u << " is:" << std::endl; 

  std::cout << derivative << std::endl;


  //part B
  part_header("B");

  Mat<double>sum(3,1);
  double interval = 0.00001;
  for( double d = 0.0; d <= 1.0; d += interval )
    {
      Mat<double>pnt;
      //get the value of the curve at d
      de_cast( d, P, pnt, plot_dat);

      //after every point, add the current value to the sum
      sum = sum+(interval*pnt);

    }

  std::cout << "The integral of the x and y coordinates for this curve is:" << std::endl; 

  std::cout << "int of x= " << sum(0) << "\t" << "int of y= " << sum(1)  << std::endl;


  //Part D
  part_header("D");

  Mat<double> pnt; 
  plot_dat.clear();
  de_cast( 0.75, P, pnt, plot_dat);
  
  std::cout << "De Casteljau output for u = 0.75:" << std::endl;
 
  for(unsigned int i = 0 ; i < plot_dat.size(); i++)
    std::cout << "Alg level " << i << ":" << std::endl << plot_dat[i]  << std::endl; 


  Mat<double>CP1;
  CP1 << 0    << 0    << 0 << endr
      << 0.75 << 1.5  << 0 << endr 
      << 2.0625 << 3.5625 << 0  << endr
      << 3.0938 << 4.0781 << 0  << endr;

  CP1= CP1.t();


  Mat<double>CP2;
  CP2 << 3.0938 << 4.0781 << 0 << endr
      << 3.4375 << 4.25 << 0 << endr
      << 3.75 << 4.25 << 0  << endr
      << 4.0 << 4.0 << 0  << endr;

  CP2 = CP2.t();



  std::ofstream data_file1;
  data_file1.open("curve1.dat");

  std::ofstream data_file2;
  data_file2.open("curve2.dat");


  std::ofstream data_file3;
  data_file3.open("orig_curve.dat");

  for(double t = 0; t < 1 ; t+=0.01)
    {

      //get value of the first curve
      de_cast( t, CP1, pnt, plot_dat);
      
      //write point to file
      data_file1 << t << "\t"  << pnt(0) << "\t" << pnt(1) << "\t" << pnt(2) << std::endl;
      
      //get value of the second curve
      de_cast( t, CP2, pnt, plot_dat);

      //write point to file
      data_file2 << t+1.0 << "\t" << pnt(0) << "\t" << pnt(1) << "\t" << pnt(2) << std::endl;

      //get value of the second curve
      de_cast( t, P, pnt, plot_dat);
      

      //write point to file
      data_file3 << t << "\t" << pnt(0) << "\t" << pnt(1) << "\t" << pnt(2) << std::endl;
	
    }

  
      
return 0;

}


void de_cast( double u, Mat<double> CP, Mat<double> &pnt, std::vector<Mat<double > > &plot_data )
{

  assert(3 == CP.n_rows);

  //add this matrix to the plot_data
  plot_data.push_back( CP );

  // if we only have one point, we're done, return the point as a matrix
  if( CP.n_cols == 1) 
    {

      pnt = CP;
      return;

    }
  // otherwise calculate the points and then recurse on the new matrix
  else
    {
      //create a new matrix for storing the values
      int new_cols = CP.n_cols - 1;
      Mat<double> N(3, new_cols);
      
      for( unsigned int i = 0; i < new_cols; i++) 
	{
	  //extract the vectors we want
	  vec A = CP.col(i);

	  vec B = CP.col(i+1);

	  //calculate the new vectors
	  vec new_vec = A + u*(B-A);
	  
	  //insert this new vector into the new matrix
	  N(0,i) = new_vec(0);
	  N(1,i) = new_vec(1);
	  N(2,i) = new_vec(2);
	  
	}
      
      de_cast( u, N, pnt, plot_data );

    }

} // end of de_cast



void de_cast_prime( double u, double order, Mat<double> CP, Mat<double> &value, std::vector<Mat<double > > &plot_data )
{

  assert(3 == CP.n_rows);

  //add this matrix to the plot_data
  plot_data.push_back( CP );

  // if we have two points, use these to compute the derivative
  if( CP.n_cols == 2) 
    {

      value = order*(CP.col(1)-CP.col(0));
      return;

    }
  // otherwise calculate the points and then recurse on the new matrix
  else
    {
      //create a new matrix for storing the values
      int new_cols = CP.n_cols - 1;
      Mat<double> N(3, new_cols);
      
      for( unsigned int i = 0; i < new_cols; i++) 
	{
	  //extract the vectors we want
	  vec A = CP.col(i);

	  vec B = CP.col(i+1);

	  //calculate the new vectors
	  vec new_vec = A + u*(B-A);
	  
	  //insert this new vector into the new matrix
	  N(0,i) = new_vec(0);
	  N(1,i) = new_vec(1);
	  N(2,i) = new_vec(2);
	  
	}
      
      de_cast_prime( u, order, N, value, plot_data );

    }

} // end of de_cast
