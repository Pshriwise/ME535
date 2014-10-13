set title 'Cubic B-Spline'
splot './BSpline.dat' u 1:2:3 w l title 'Bspline curve', './CP.dat' u 1:2:3 lc rgb 'blue' title 'Control Points'
pause -1
