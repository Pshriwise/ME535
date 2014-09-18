


#include <iostream>
#include <fstream>
#include <armadillo>

using namespace arma;


void create_gnuplot_script( std::vector<std::string> filenames );

int main(int argc, char** argv)
{

  int u_pnts= 20;


  std::vector<std::string> filenames;

      //create the point and vector arrays using the form 
      //[x0, x1, dx0, dx1; y0 y1l dy0, dy1; z0, z1, dz0, dz1]
      
      double m = 1/(double(u_pnts)-1);



      //create the data points here
      std::vector<double> x,y,z;

      for(int i=0; i < u_pnts; i++)
	{
	  double t = double(i)*m;
	  //polynomial for x
	  x.push_back( t + 9*pow(t,2) - 6*pow(t,3) );
	  y.push_back( t + 4*pow(t,2) - 5*pow(t,3) );
	  z.push_back( 0 );

	}
      
      std::ofstream data_file;


      //create the filename
      std::ostringstream data_filename;
      data_filename << "Problem2.dat";
      filenames.push_back( data_filename.str() );
     
      data_file.open(&(data_filename.str()[0]) );


      for(unsigned int i = 0; i < x.size(); i++)
	{

	  data_file << x[i] << "\t" << y[i] << "\t" << z[i] << "\n";
	  
	}

      data_file.close();



  create_gnuplot_script( filenames );
  
  return 0;

  
}


void create_gnuplot_script( std::vector<std::string> filenames ) 
{
  
  std::ofstream gp_script;
  
  gp_script.open("Problem2_gp.p");

  gp_script << "#Name: Patrick Shriwise \t Date: 9/22/14 \n" ;
  gp_script << "#This is a gnuplot file for ploting data for Problem 2 in HW 1 \n";
  gp_script << "#for ME 535 at the University of Wisconsin - Madison\n \n";

  gp_script << "# This will plot the Hermite curve with P0 = (0,0,0) P1 = (4,0,0)\n";
  gp_script << "# P'0 = (1,4,0) and P'1 = (1,-4,0). It does so using the polynomial\n";
  gp_script << "# rather than the matrix forms as before\n";

  gp_script << "plot ";
  for(unsigned int i = 0; i < filenames.size(); i++){
    gp_script << "'" << filenames[i] << "' using 1:2";
      if( i != filenames.size()-1) gp_script <<", \\\n";
  }
  gp_script << "\n";
  
  gp_script << "set xlabel 'x' \n";
  gp_script << "set ylabel 'y' \n";
  gp_script << "set zlabel 'z' \n";
  gp_script << "set title 'HW1_Problem2' \n";
  gp_script << "set mytics '4' \n";
  gp_script << "set mxtics '4' \n";
  gp_script << "set nokey \n";
  //no more settings after here
  gp_script << "replot \n";
  gp_script << "\n"; gp_script << "pause -1";
  gp_script.close();
}

