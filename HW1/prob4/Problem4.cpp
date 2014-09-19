


#include <iostream>
#include <fstream>
#include <armadillo>
#include <assert.h>

using namespace arma;


void de_cast( double u, Mat<double> CP, Mat<double> &pnt, std::vector<Mat<double > > &plot_data );
void create_gnuplot_script( std::vector<std::string> filenames );

int main(int argc, char** argv)
{

  std::vector<std::string> filenames;

  int u_pnts = 20;
  double u = 0.5;

  // setup the point matrix
  Mat<double> P;
  P << 0 << 0 << 0 << endr
    << 1 << 2 << 0 << endr
    << 3 << 5 << 0 << endr
    << 4 << 4 << 0 << endr
    << 5 << 0 << 0 << endr;

  P = P.t();
  

  std::vector<Mat<double> > plot_data;

  Mat<double> pnt(3,1);
  de_cast( u, P, pnt, plot_data );

  
  //first, let's use de_cast to create the curve
  
  double m = 1/(double(u_pnts)-1);
      
  Mat<double> curve(3,u_pnts);
  for(int i=0; i < u_pnts; i++)
    {
      u = double(i)*m;

      de_cast( u, P, pnt, plot_data );
      
      curve(0,i) = pnt(0,0);
      curve(1,i) = pnt(1,0);
      curve(2,i) = pnt(2,0);

    }

  //write the curve points to a data file
  std::ofstream data_file;
  
  //create the filename
  std::ostringstream data_filename;
  data_filename << "Problem4_curve.dat";
  filenames.push_back( data_filename.str() );
  
  data_file.open(&(data_filename.str()[0]) );
  
  for(unsigned int i = 0; i < curve.n_cols; i++)
    {
      
      data_file << curve(0,i) << "\t" << curve(1,i) << "\t" << curve(2,i) << "\n";
      
    }
  
  //make sure the plot_data is cleared 
  plot_data.clear();
  
  data_file.close();


  //use the algorithm to get the specific points of u we want and send the plotting data out to a new file

  double u_vals[3] = { 0.2, 0.5, 0.8 };

  for( unsigned int i = 0; i < 3 ; i++)
    {

      //run the de_cast algorithm for this u value
      de_cast( u_vals[i], P, pnt, plot_data);

     //use the plot data to write to a new output file

      std::ostringstream filename;
      filename << "Problem4_u=" << u_vals[i] << ".dat";

      filenames.push_back( filename.str() );
      data_file.open( &(filename.str()[0]) );

      // for each matrix, plot the points
      for(std::vector<Mat<double> >::iterator j = plot_data.begin();
	  j != plot_data.end(); j++)
	{

	  Mat<double> this_mat = *j;
	  for( unsigned int k =0; k < this_mat.n_cols; k++)
	    data_file << this_mat(0,k) << "\t" << this_mat(1,k)
		      << "\t" << this_mat(2,k) << "\n";

	  data_file << "\n";
	}

      //make sure the plot_data is cleared 
      plot_data.clear();
  
      data_file.close();
    }

  create_gnuplot_script( filenames );

  return 0;
}


void create_gnuplot_script( std::vector<std::string> filenames ) 
{
  
  std::ofstream gp_script;
  
  gp_script.open("Problem4_gp.p");

  gp_script << "#Name: Patrick Shriwise \t Date: 9/22/14 \n" ;
  gp_script << "#This is a gnuplot file for ploting data for Problem 3 in HW 1 \n";
  gp_script << "#for ME 535 at the University of Wisconsin - Madison\n \n";

  gp_script << "#This script plots a 4th degree Bezier curve using the points:\n";
  gp_script << "# [0,0;1,2;3,5;4,4;5,0]\n";
  gp_script << "# It also shows the process behind De Casteljau's Algorithm for plotting Bezier curve points\n";

  //get the curve filename
  std::string curve_datafile = filenames[0];
  // plot the full curve first
  gp_script << "plot ";
  //assume the curve infor is in the first filename
  gp_script << "'" <<curve_datafile << "'"<< " using 1:2 w lines lc rgb 'blue', \\\n";
  gp_script << "'" <<curve_datafile << "'"<< " using 1:2 lc rgb 'blue' pt 7\n";
  gp_script << "set xlabel 'x' \n";
  gp_script << "set ylabel 'y' \n";
  gp_script << "set zlabel 'z' \n";
  gp_script << "set title 'HW1_Problem4 De Casteljau Algorithm (whole curve)' \n";
  gp_script << "set mytics '4' \n";
  gp_script << "set mxtics '4' \n";
  gp_script << "set nokey \n";
  //no more settings after here
  gp_script << "replot \n";
  gp_script << "set output 'Problem4_whole_curve.png'";
  gp_script << "\n"; gp_script << "pause -1\n";

  for(unsigned int i = 1; i < filenames.size(); i++){
  

    std::string dcalg_datafile = filenames[i];
    std::string u_val = filenames[i].substr(9,100);
    //remove the ".dat" from the filename
    u_val.erase( u_val.end()-4, u_val.end() );
    gp_script<< "plot ";
    //plot the normal curve
    gp_script << "'" <<curve_datafile << "'"<< " using 1:2 w lines lc rgb 'black', \\\n";
    //now plot the algorithm data w/ this
    gp_script << "'" << dcalg_datafile << "'" << " using 1:2 w lines lc rgb 'blue', \\\n";
    gp_script << "'" << dcalg_datafile << "'" << " using 1:2 lc rgb 'red' pt 7 \n";
    
  
    gp_script << "set xlabel 'x' \n";
    gp_script << "set ylabel 'y' \n";
    gp_script << "set zlabel 'z' \n";
    gp_script << "set title 'HW1_Problem4 De Casteljau Algorithm for " << u_val << "' \n";
    gp_script << "set mytics '4' \n";
    gp_script << "set mxtics '4' \n";
    gp_script << "set nokey \n";

    //no more settings after here
    gp_script << "replot \n";
    gp_script << "set output 'Problem4_" << u_val << "_w_alg.png'";
    gp_script << "\n"; gp_script << "pause -1";
    gp_script << std::endl;
  }

  gp_script.close();
}

// plot data will contain all information if the user wants to plot
// the progression of the algorithm
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





}
