
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



void Bezier_bicubic_patch( field<vec> cps, double u, double v, Mat<double> &pnt, bool nurbs) 
{


  Row<double> U,V;
  U << pow(u,3) << pow(u,2) << u << 1;
  V << pow(v,3) << pow(v,2) << v << 1; 

  Mat<double> M;
  
  M << -1  <<  3  << -3  << 1 << endr
    <<  3  << -6  <<  3  << 0 << endr
    << -3  <<  3  <<  0  << 0 << endr
    <<  1  <<  0  <<  0  << 0 << endr; 
  
  Mat<double> X(4,4),Y(4,4),Z(4,4),W(4,4);
  for(unsigned int i = 0; i < cps.n_rows; i++)
    for(unsigned int j = 0; j < cps.n_cols; j++)
      {{
	  X(i,j) = cps(i,j)(0);
	  Y(i,j) = cps(i,j)(1);
	  Z(i,j) = cps(i,j)(2);
	  if(nurbs) W(i,j) = cps(i,j)(3);
	  
	}}
  pnt.resize(cps(0,0).n_rows,1); 
  Mat<double> temp; 
  temp = U*M*X*M.t()*V.t(); pnt(0,0) = temp(0,0); 
  temp = U*M*Y*M.t()*V.t(); pnt(1,0) = temp(0,0); 
  temp = U*M*Z*M.t()*V.t(); pnt(2,0) = temp(0,0); 
  if(nurbs) temp = U*M*W*M.t()*V.t(); pnt(3,0) = temp(0,0); 



}
