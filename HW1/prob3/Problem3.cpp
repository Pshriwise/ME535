


#include <iostream>
#include <fstream>
#include <armadillo>

using namespace arma;


void create_gnuplot_script( std::vector<std::string> filenames );

int main(int argc, char** argv)
{

  int u_pnts= 20;


  std::vector<std::string> filenames;

      std::cout << "--------------------------------------" << std::endl;


      //create the point array (5 points)
      
      
      // setup the point matrix
      double p[15]= { 0,        0,        0,
		      1,        2,        0,
		      3,        5,        0,
		      4,        4,        0,
                      5,        5,        0 };
  
      Mat<double> P(p,3,5,false);
      P=P.t(); // have to do this because of the way that armadillo reads values into matrices
      std::cout << "P Matrix:" << std::endl;
      std::cout << P << std::endl;
      
      // now setup the coefficients for the basis matrix
      double b[25]   =  {    1,  -4,   6,  -4, 1,
			    -4,  12, -12,   4, 0, 
			     6, -12,   6,   0, 0,
			    -4,   4,   0,   0, 0, 
			     1,   0,   0,   0, 0 };
      
      Mat<double> B(b,5,5,false);
      B=B.t(); // have to do this because of the way that armadillo reads values into matrices
      std::cout << "B Matrix:" << std::endl;
      std::cout << B << std::endl;
      
      //setup the parameter sweep along u
      Mat<double> T;
      T.set_size(5,u_pnts);
      
      double m = 1/(double(u_pnts)-1);
      
      for(int i=0; i < u_pnts; i++)
	{
	  double t = double(i)*m;
	  T(0,i) = pow(t,4);
	  T(1,i) = pow(t,3);
	  T(2,i) = pow(t,2);
	  T(3,i) = t;
	  T(4,i) = 1;
	}
      
      T=T.t();  // doing this so that the martix has the right form (n x 5)
      Mat<double> Q = T*B*P;
      
      //transform the answer so its easier to write to a file...
      Q=Q.t();
      
      std::ofstream data_file;

      //create the filename
      std::ostringstream data_filename;
      data_filename << "Problem3.dat";
      filenames.push_back( data_filename.str() );
     
      data_file.open(&(data_filename.str()[0]) );

      for(unsigned int i = 0; i < Q.n_cols; i++)
	{

	  data_file << Q(0,i) << "\t" << Q(1,i) << "\t" << Q(2,i) << "\n";
	  
	}

      data_file.close();

      std::cout << "--------------------------------------" << std::endl;
      
      


  create_gnuplot_script( filenames );
  
  return 0;

  
}


void create_gnuplot_script( std::vector<std::string> filenames ) 
{
  
  std::ofstream gp_script;
  
  gp_script.open("Problem1_gp.p");

  gp_script << "#Name: Patrick Shriwise \t Date: 9/22/14 \n" ;
  gp_script << "#This is a gnuplot file for ploting data for Problem 1 in HW 1 \n";
  gp_script << "#for ME 535 at the University of Wisconsin - Madison\n \n";

  gp_script << "#This file will generate the plot for each k in a new color with \n";
  gp_script << "#with a legend to indicate which curve matches which k. \n";

  gp_script << "plot ";
  for(unsigned int i = 0; i < filenames.size(); i++){
    gp_script << "'" << filenames[i] << "' using 1:2" << " title " << "'" << filenames[i].substr(9,100) << "'";
      if( i != filenames.size()-1) gp_script <<", \\\n";
  }
  gp_script << "\n";
  
  gp_script << "set xlabel 'x' \n";
  gp_script << "set ylabel 'y' \n";
  gp_script << "set zlabel 'z' \n";
  gp_script << "set title 'HW1_Problem1' \n";
  gp_script << "set mytics '4' \n";
  gp_script << "set mxtics '4' \n";
  
  //no more settings after here
  gp_script << "replot \n";
  gp_script << "set output 'Problem1.png'\n";
  gp_script << "\n"; gp_script << "pause -1";
  gp_script.close();
}

