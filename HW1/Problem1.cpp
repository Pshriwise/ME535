


#include <iostream>
#include <fstream>
#include <armadillo>

using namespace arma;

int main(int argc, char** argv)
{


  double k =1;
  int u_pnts= 20;

  //create the point and vector arrays using the form 
  //[x0, x1, dx0, dx1; y0 y1l dy0, dy1; z0, z1, dz0, dz1]

  double p[12]= { 4,        4,        0,
		  24,       4,        0,
		  0.8320*k, 0.5547*k, 0,
		  0.8320,   -0.5547,  0};
  
  Mat<double> P(p,3,4,false);
  std::cout << P.t() << std::endl;

  double b[16]   = { 2, -2,  1, 1,
		    -3,  3, -2, 1,
		     0,  0,  1, 0,
		     1,  0,  0, 0};

  Mat<double> B(b,4,4,false);
  std::cout << B.t() << std::endl;

  Mat<double> T;
  T.set_size(4,u_pnts);

  double m = 1/(double(u_pnts)-1);

  for(int i=0; i < u_pnts; i++)
    {
      double t = double(i)*m;
      std::cout << t << std::endl;
      T(0,i) = pow(t,3);
      T(1,i) = pow(t,2);
      T(2,i) = t;
      T(3,i) = 1;
    }

  std::cout << T.t() << std::endl;

  Mat<double> Q = T.t()*B.t()*P.t();

  Q=Q.t();

  std::ofstream data_file;
  data_file.open("Problem1.dat");

  for(unsigned int i = 0; i < Q.n_cols; i++)
    {

      data_file << Q(0,i) << "\t" << Q(1,i) << "\t" << Q(2,i) << "\n";

    }

  data_file.close();


  return 0;

  
}
