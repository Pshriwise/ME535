set title 'Cubic B-Spline'
plot './BSpline.dat' u 1:2 w l title 'Bspline curve', './CP.dat' u 1:2 lc rgb 'blue' title 'Control Points'
pause -1
