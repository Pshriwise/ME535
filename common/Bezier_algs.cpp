
#include <armadillo>
#include <assert.h>

using namespace arma;


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
