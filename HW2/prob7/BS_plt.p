set title 'Cubic B-Spline'
set xrange [-0.5:3.5]
plot './BSpline.dat' u 1:2 w l title 'Bspline curve', './CP.dat' u 1:2 lc rgb 'blue' title 'Control Points', './CP.dat' u 1:2 w l lc rgb 'blue' title ''
pause -1
