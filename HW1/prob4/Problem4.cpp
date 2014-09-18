


#include <iostream>
#include <fstream>
#include <armadillo>
#include <assert.h>

using namespace arma;


void de_cast( double u, Mat<double> CP, Mat<double> &pnt );

int main(int argc, char** argv)
{

  double u = 0.5;

  // setup the point matrix
  Mat<double> P;
  P << 0 << 0 << 0 << endr
    << 1 << 2 << 0 << endr
    << 3 << 5 << 0 << endr
    << 4 << 4 << 0 << endr
    << 5 << 0 << 0 << endr;

  P = P.t();
  std::cout << P.col(0) << std::endl;

  std::vector<Mat<double> > plot_data;

  Mat<double> pnt(3,1);
  de_cast( u, P, pnt );

  std::cout << pnt << std::endl;

  return 0;
}



void de_cast( double u, Mat<double> CP, Mat<double> &pnt)
{

  assert(3 == CP.n_rows);

  if( CP.n_cols == 1) 
    {

      pnt = CP;
      return;

    }
  else
    {
      //create a new matrix for storing the values
      int new_cols = CP.n_cols - 1;
      Mat<double> N(3, new_cols);
      
      for( unsigned int i = 0; i < new_cols; i++) 
	{
	  //extract the vectors we want
	  vec A(3);
	  A(0) = CP(0,i);
	  A(1) = CP(1,i);	    
	  A(2) = CP(2,i);	    

	  vec B(3);
	  B(0) = CP(0, i+1);
	  B(1) = CP(1, i+1);
	  B(2) = CP(2, i+1);
	  
	  //calculate the new vectors
	  vec new_vec = A + u*(B-A);
	  
	  //insert this new vector into the new matrix
	  N(0,i) = new_vec(0);
	  N(1,i) = new_vec(1);
	  N(2,i) = new_vec(2);
	  
	}
      
      de_cast( u, N, pnt );

    }





}
