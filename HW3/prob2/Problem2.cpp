

#include <fstream>
#include <iostream>
#include <assert.h>
#include <math.h>
#include <armadillo>
#include "formatting.hpp"
#include "BSpline_algs.hpp"
#include "Bezier_algs.hpp"
#include "Coons.hpp"
#include "Ferguson.hpp"

using namespace arma;

Row<double> c1 (double u);
Row<double> c2 (double u);
Row<double> c3 (double u);
Row<double> c4 (double u);


int main( int argc, char** argv)
{

  part_header("A");

  //setup knot vector
  std::cout << "The knot values in u and v are: " << std::endl;  
  double ku [] = { 0, 0, 1, 1 };
  std::vector<double> knots_u( ku, ku+ (sizeof(ku)/sizeof(ku[0]) ) );
  std::cout << std::endl << "U" << std::endl;
  for(unsigned int i = 0; i < knots_u.size(); i++ )std::cout << knots_u[i] << std::endl; 


  double kv [] = { 0, 1 };
  std::vector<double> knots_v( kv, kv+ (sizeof(kv)/sizeof(kv[0]) ) );
  std::cout << std::endl << "V" << std::endl;  
  for(unsigned int i = 0; i < knots_v.size(); i++ )std::cout << knots_v[i] << std::endl; 

  std::cout << "The weight values are:" << std::endl; 
  double w [] = { 1, cos(M_PI/4), 1 };
  std::vector<double> weights( w, w + (sizeof(w)/sizeof(w[0]) ) );
  for(unsigned int i = 0; i < weights.size(); i++ )std::cout << weights[i] << std::endl; 

  field<vec> CPS(2,3);
  // enter CPs in respective groups for v
  CPS(0,0) << 1 << 0 << 0 << 1;
  CPS(0,1) << 1 << 1 << 0 << 1;
  CPS(0,2) << 0 << 1 << 0 << 1;

  CPS(1,0) << 1 << 0 << 1 << 1;
  CPS(1,1) << 1 << 1 << 1 << 1;
  CPS(1,2) << 0 << 1 << 1 << 1;

  std::cout << "The matrix of control points looks like" << std::endl; 
  std::cout << CPS << std::endl; 

  //apply weights

  for( unsigned int i = 0; i < weights.size(); i++) 
    {
      CPS(0,i) *= weights[i];
      CPS(1,i) *= weights[i];
    }

  //std::cout << CPS << std::endl; 

  //std::cout << CPS(0,0).size() << std::endl; 

  Mat<double> pnt;
  
  int u_deg = 2;
  int v_deg = 1;

  Mat<double> Surf(0,0);
  for( double u = 0 ; u <=1 ; u+=0.01)
    for( double v = 0 ; v<=1 ; v+=0.01)
      {
	{
	  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, u, v, pnt, PNT);
	  //remove weight
	  pnt.col(0) = pnt.col(0)/pnt(3);
	  Surf.insert_cols(Surf.n_cols,pnt.col(0));
	}
      }


  std::ofstream datafile; 
  datafile.open("NURBS_data.dat");

  datafile << Surf.t();

  datafile.close();


  part_header("B");
  pnt.clear();
  std::cout << "The value of the surface at u=0.5 and v=0.5 is:" << std::endl;
  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, 0.5, 0.5, pnt, PNT, true);
  std::cout << pnt << std::endl; 
  std::cout << "The value of the derivative in u at u=0.5 and v=0.5 is:" << std::endl;
  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, 0.5, 0.5, pnt, DERIV_U, true);
  std::cout << pnt << std::endl; 
  std::cout << "The value of the deriative in v at u=0.5 and v=0.5 is:" << std::endl;
  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, 0.5, 0.5, pnt, DERIV_V, true);
  std::cout << pnt << std::endl; 
  std::cout << "The value of the derivative in u and v at u=0.5 and v=0.5 is:" << std::endl;
  surf_de_boor( u_deg, v_deg, CPS, knots_u, knots_v, 0.5, 0.5, pnt, DERIV_UV, true);
  std::cout << pnt << std::endl; 

  part_header("C"); 


  //function pointers for the coons surface
  std::vector< Row<double>(*)(double) > func_ptrs; 

  func_ptrs.push_back(c1);
  func_ptrs.push_back(c2);   
  func_ptrs.push_back(c3);   
  func_ptrs.push_back(c4); 

  Mat<double>surf(0,0);
  //sweet the parameter space, add to a matrix as we do so
  for(double u = 0; u < 1; u+=0.01){
    for(double v= 0; v < 1 ; v+=0.01){
      surf.insert_rows(surf.n_rows, coons_value( func_ptrs, u, v)); 
    }}

  std::cout << "The value of the Coons surface at u=v=0.5 is" << std::endl; 

  std::cout << coons_value( func_ptrs, 0.5, 0.5) << std::endl; 

  std::ofstream datafile1; 
  datafile1.open("Coons_data.dat"); 
  
  datafile1 << surf;

  datafile1.close(); 


  part_header("D"); 

  field<vec> BCPS(4,4);

  double val = cos(M_PI/4); 

  double bw [] = { 1, (1+val)/2, (1+val)/2, 1 };
  std::vector<double> bezier_weights( bw, bw + (sizeof(bw)/sizeof(bw[0]) ) );

  for(unsigned int  i = 0; i <=3 ; i++)
    {
      double z = (double)i*(1.0/3.0);
      BCPS(i,0) << 1 << 0  << z << 1 << endr;
      BCPS(i,0) = bezier_weights[0]*BCPS(i,0);
      BCPS(i,1) << 1 << val/(1+val)  << z << 1 << endr;
      BCPS(i,1) = bezier_weights[1]*BCPS(i,1);
      BCPS(i,2) << val/(1+val) << 1 << z << 1 << endr;
      BCPS(i,2) = bezier_weights[2]*BCPS(i,2);
      BCPS(i,3) << 0 << 1 << z << 1 << endr; 
      BCPS(i,3) = bezier_weights[3]*BCPS(i,3);

    }

  //std::cout << BCPS << std::endl; 

  pnt.clear(); 

  std::ofstream datafile2;
  datafile2.open("bicubic_data.dat");

  for(double u = 0; u<=1; u+=0.01)
    for(double v = 0; v<=1; v+=0.01)
      {{
	  Bezier_bicubic_patch( BCPS, u, v, pnt, true); 
	  datafile2 << pnt.t()/pnt(3,0);
	}}

  datafile2.close();

  Bezier_bicubic_patch( BCPS, 0.5, 0.5, pnt, true); 
  std::cout << "Bezier bicubic surface at u = 0.5, v= 0.5: " << std::endl; 
  std::cout << pnt/pnt(3,0) << std::endl; 

  part_header("E");

  //setup control points
  field<vec> FCPS(4,4);
  //corners  
  FCPS(0,0) << 1 << 0 << 0 << endr; 
  FCPS(1,0) << 0 << 1 << 0 << endr; 
  FCPS(0,1) << 1 << 0 << 1 << endr; 
  FCPS(1,1) << 0 << 1 << 1 << endr;

  //tanget vectors in u 
  FCPS(2,0) << 0 << 1 << 0 << endr; 
  FCPS(3,0) << -1 << 0 << 0 << endr;
  FCPS(2,1) = FCPS(2,0);
  FCPS(3,1) = FCPS(3,0);

  //tangent vectors in v
  FCPS(0,2) << 0 << 0 << 1 << endr; 
  FCPS(1,2) << 0 << 0 << 1 << endr;
  FCPS(0,3) << 0 << 0 << 1 << endr; 
  FCPS(1,3) << 0 << 0 << 1 << endr; 
  
  //fill in 
  FCPS(2,2) << 0 << 0 << 0 << endr; 
  FCPS(2,3) = FCPS(2,2);
  FCPS(3,2) = FCPS(2,2);
  FCPS(3,3) = FCPS(2,2);
  
  //std::cout << FCPS << std::endl; 

  
  
  
  std::ofstream datafile3;
  datafile3.open("Ferg_data.dat"); 
  
  for(double u = 0; u<=1; u+=0.01)
    for(double v = 0; v<=1; v+=0.01)
      {{
	  datafile3 << ferg_surf(FCPS,u,v);
	}}

  datafile3.close();

  Row<double> fpnt = ferg_surf( FCPS, 0.5, 0.5); 
  std::cout << "Ferguson surface at u = 0.5, v= 0.5: " << std::endl; 
  std::cout << fpnt << std::endl; 
  
  return 0;

}



Row<double> c1 (double u) 
{

  double ku [] = { 0, 0, 1, 1 };
  std::vector<double> knots_u( ku, ku+ (sizeof(ku)/sizeof(ku[0]) ) );

  double w [] = { 1, cos(M_PI/4), 1 };
  std::vector<double> weights( w, w + (sizeof(w)/sizeof(w[0]) ) );

  Mat<double> cps; 
  cps << 1 << 0 << 0 << 1 << endr
      << 1 << 1 << 0 << 1 << endr
      << 0 << 1 << 0 << 1 << endr;

  cps=cps.t();

  //apply weights 
  for(unsigned int i = 0; i < cps.n_cols; i++) cps.col(i) = weights[i]*cps.col(i);

  Mat<double> pnt; 
  //return point at u
  blossom_de_boor( 2, cps, knots_u, u, pnt, false); 
  pnt = pnt.submat(0,0,pnt.n_rows-2,0)/pnt(3);
  
  return pnt.t();
 
}

Row<double> c2 (double u)
{

  Row<double> pnt(3); 

  pnt(0) = 1; 
  pnt(1) = 0;
  pnt(2) = u; 

  return pnt; 

}

Row<double> c3 (double u) 
{

  double ku [] = { 0, 0, 1, 1 };
  std::vector<double> knots_u( ku, ku+ (sizeof(ku)/sizeof(ku[0]) ) );

  double w [] = { 1, cos(M_PI/4), 1 };
  std::vector<double> weights( w, w + (sizeof(w)/sizeof(w[0]) ) );

  Mat<double> cps; 
  cps << 1 << 0 << 1 << 1 << endr
      << 1 << 1 << 1 << 1 << endr
      << 0 << 1 << 1 << 1 << endr;

  cps=cps.t();

  //apply weights 
  for(unsigned int i = 0; i < cps.n_cols; i++) cps.col(i) = weights[i]*cps.col(i);

  Mat<double> pnt; 
  //return point at u
  blossom_de_boor( 2, cps, knots_u, u, pnt, false); 
  pnt = pnt.submat(0,0,pnt.n_rows-2,0)/pnt(3);
  
  return pnt.t();

  
}


Row<double> c4 (double u)
{

  Row<double> pnt(3); 

  pnt(0) = 0; 
  pnt(1) = 1;
  pnt(2) = u; 

  return pnt; 

}
