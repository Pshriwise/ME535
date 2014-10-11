

#include <fstream>
#include <iostream>
#include <assert.h>
#include <armadillo>
#include "formatting.hpp"

using namespace arma;

void blossom_de_boor( int degree, Mat<double> cps, std::vector<double> knots, double u, Mat<double> &pnt);

void find_pnt( Mat<double> base, std::vector<double> knots, Mat<double> &pnt, double u );

int main( int argc, char** argv)
{



  //setup knot vector
  double k [] = { -2, -1, 0, 2, 4, 5, 6, 6};
  std::vector<double> knots( k, k+ (sizeof(k)/sizeof(k[0]) ) );


  Mat<double> CPs;
  
  CPs << 0 << 0 << 0 << endr
      << 1 << 0 << 0 << endr
      << 1 << 1 << 0 << endr
      << 0 << 2 << 0 << endr
      << 2 << 2 << 0 << endr;


  CPs=CPs.t();
  

  Mat<double> pnt;
  
  blossom_de_boor( 3, CPs, knots, 1, pnt);



  std::cout << pnt << std::endl; 




  return 0;

}


void blossom_de_boor( int degree, Mat<double> cps, std::vector<double> knots, double u, Mat<double> &pnt )
{


  //make sure the u-value is valid
  if( u < knots[degree-1] || u > knots[ knots.size() - (degree-1)] )
    {
      std::cout << "Invalid u-value passed to blossom_de_boor" << std::endl; 
      assert(false);
    }

  int interval = -1;
  //figure out what interval of the curve we're on
  for( unsigned int i = 0 ; i < knots.size()-1 ; i ++ ) 
    {
      
      if( u >= knots[i] && u < knots[i+1] )
	{
	  interval= i-(degree-1);
	  break;
	}
      
    }
  
  
  assert( 0 <= interval );

  Mat<double> base; 

  base = cps.submat(0, interval, 2,interval+degree);
  
  std::vector<double>sub_knots; 
  sub_knots.insert(sub_knots.begin(), knots.begin()+interval, knots.begin()+interval+(degree*2) );


  find_pnt( base, sub_knots, pnt, u);

}


void find_pnt( Mat<double> base, std::vector<double> knots, Mat<double> &pnt, double u )
{


  if ( 1 == base.n_cols ) 
    {
      pnt = base.col(0);
      return;
    }
  int offset = base.n_cols-1; 


  Mat<double> new_base(3,offset);


  for( unsigned int i = 0 ; i < offset ; i ++)
    {
      double coeff1 = (double(knots[i+offset])-u)/double(knots[i+offset]-knots[i]);

      double coeff2 = (u - double(knots[i]))/double(knots[i+offset]-knots[i]);

      new_base.col(i)= coeff1*base.col(i) + coeff2*base.col(i+1);

      
     
     
     

    }
      
  //remove the fisrt and last knot before the recursive call 
  std::vector<double> new_knots;
  new_knots.insert(new_knots.begin(), knots.begin()+1, knots.end()-1);


  find_pnt(new_base, new_knots, pnt, u);

}
      
      

 
