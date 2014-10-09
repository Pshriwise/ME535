

#include <armadillo>
#include <assert.h>

using namespace arma;


void de_cast( double u, Mat<double> CP, Mat<double> &pnt, std::vector<Mat<double > > &plot_data );

void de_cast_prime( double u, double order, Mat<double> CP, Mat<double> &value, std::vector<Mat<double > > &plot_data );
