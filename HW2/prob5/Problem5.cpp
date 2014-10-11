

#include <fstream>
#include <iostream>
#include <assert.h>
#include <armadillo>
#include "formatting.hpp"

using namespace arma;

void blossom_de_boor( int degree, Mat<double> cps, std::vector<double> knots, double u, Mat<double> &pnt, bool deriv = false);

void find_pnt( Mat<double> base, std::vector<double> knots, Mat<double> &pnt, double u );


void find_slope( Mat<double> base, std::vector<double> knots, Mat<double> deriv, double u);

int main( int argc, char** argv)
{



  //setup knot vector
  double k [] = { -2, -1, 0, 2, 4, 5, 6, 6};
  std::vector<double> knots( k, k+ (sizeof(k)/sizeof(k[0]) ) );


  Mat<double> CPs;
  
  CPs << 0 << 0 << 0 << endr
      << 1 << 0 << 0 << endr
      << 1 << 1 << 0 << endr
      << 0 << 1 << 0 << endr
      << 0 << 2 << 0 << endr
      << 2 << 2 << 0 << endr;


  CPs=CPs.t();
  

  Mat<double> pnt;
  
  int degree = 3;
  double start = knots[degree-1];
  double end = knots[knots.size()-(degree)];

  std::ofstream datafile;
  datafile.open("BSpline.dat");
  
 
  for( double u = start; u <= end; u+=(end-start)/100 )
    {
      blossom_de_boor( degree, CPs, knots, u, pnt);
      datafile << pnt(0) << "\t" << pnt(1) <<  "\t" << pnt(2) << std::endl; 
    }

  datafile.close();
  std::ofstream CPfile; 
  CPfile.open("CP.dat");
  CPfile << CPs.t();
  CPfile.close();

  part_header("B");
  
  double t = 3;
  std::cout << "The derivative of the B-Spline at t= " << t << ":" << std::endl; 

  blossom_de_boor(degree, CPs, knots, t, pnt, true);

  std::cout << pnt << std::endl; 


  return 0;

}


void blossom_de_boor( int degree, Mat<double> cps, std::vector<double> knots, double u, Mat<double> &pnt, bool deriv )
{


  //make sure the u-value is valid
  if( u < knots[degree-1] || u > knots[ knots.size() - (degree)] )
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

  base = cps.submat(0, interval, 2, interval+(degree));
  
  std::vector<double>sub_knots; 
  sub_knots.insert(sub_knots.begin(), knots.begin()+interval, knots.begin()+interval+(degree*2) );


  if(deriv)
    {
      find_slope(base, sub_knots, pnt, u);
      pnt= degree*pnt;
    }
  else
    {
      find_pnt( base, sub_knots, pnt, u);
    }
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
      
      
void find_slope( Mat<double> base, std::vector<double> knots, Mat<double> deriv, double u)
{

  if ( 2 == base.n_cols ) 
    {
      deriv = (1/(knots[1]-knots[0]))*(base.col(1)-base.col(0));
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


  find_slope(new_base, new_knots, deriv, u);

}

 
