

#include <armadillo>
#include "BSpline_algs.hpp"
#include <assert.h>

using namespace arma;

void surf_de_boor( int degree_u, int degree_v,  field<vec> cps, std::vector<double> knots_u, std::vector<double> knots_v, double u, double v, Mat<double> &pnt )
{

  //first we'll reduce the v direction
  Mat<double> u_pnts(0,0);
  Mat<double> v_pnts;//(cps(0,0).size(), cps.n_rows );
  
  for( unsigned int i = 0; i < cps.n_cols; i++)
    {
      
      //use the all vectors of this column to make the new matrix of v_pnts
      for(unsigned int j=0; j<cps.n_rows; j++) v_pnts.insert_cols( j, cps(j,i) );
      //std::cout << v_pnts << std::endl; 
      //now send this off to blossom_de_boor and add the returned point onto the u_pnts
      Mat<double> v_pnt;
      blossom_de_boor( degree_v, v_pnts, knots_v, v, v_pnt, false);

      u_pnts.insert_cols(u_pnts.n_cols, v_pnt.col(0));

      //reset these for the next round
      v_pnt.clear();
      v_pnts.clear();
    }
  
  //now we'll do a reduction in u as we normally do, but with the new u cps
  
  //std::cout << u_pnts << std::endl; 
  blossom_de_boor( degree_u, u_pnts, knots_u, u, pnt, true);

  
}


void set_bspline_params( int degree, Mat<double> cps, std::vector<double> knots, double u, Mat<double> &base, std::vector<double> &sub_knots )
{
  
  base.clear();
  sub_knots.clear();
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

  base = cps.cols(interval, interval+(degree));
  
  sub_knots.insert(sub_knots.begin(), knots.begin()+interval, knots.begin()+interval+(degree*2) );

}

void blossom_de_boor( int degree, Mat<double> cps, std::vector<double> knots, double u, Mat<double> &pnt, bool deriv )
{

  Mat<double> base; 
  std::vector<double> sub_knots; 

  set_bspline_params( degree, cps, knots, u, base, sub_knots);

  if(deriv)
    {
      find_slope(base, sub_knots, pnt, u);
      pnt = (degree/(sub_knots[1]-sub_knots[0]))*(pnt.col(1)-pnt.col(0));
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


  Mat<double> new_base(base.n_rows,offset);


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
      
      
void find_slope( Mat<double> base, std::vector<double> &knots, Mat<double> &deriv_pnts, double u)
{

  if ( 2 == base.n_cols ) 
    {
      deriv_pnts = base;
      return;
    }
  int offset = base.n_cols-1; 


  Mat<double> new_base(base.n_rows,offset);


  for( unsigned int i = 0 ; i < offset ; i ++)
    {
      double coeff1 = (double(knots[i+offset])-u)/double(knots[i+offset]-knots[i]);

      double coeff2 = (u - double(knots[i]))/double(knots[i+offset]-knots[i]);

      new_base.col(i)= coeff1*base.col(i) + coeff2*base.col(i+1);

    }
      
  //remove the fisrt and last knot before the recursive call 
  std::vector<double> new_knots;
  new_knots.insert(new_knots.begin(), knots.begin()+1, knots.end()-1);
  knots = new_knots;

  find_slope(new_base, knots, deriv_pnts, u);

}
