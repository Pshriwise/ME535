set title 'Cubic B-Spline'
plot './BSpline.dat' u 1:2 w l title 'Bspline curve', './CP.dat' u 1:2 lc rgb 'blue' title 'Control Points', 'Unit_Circ.dat' u 1:2 lc rgb 'black' title 'Actual Unit Circle'
pause -1
