set title 'NURBS - Unit Circle'
set grid
set yrange [-1.5:2.5]
plot './BSpline.dat' u 1:2 w l title 'Bspline curve', './CP.dat' u 1:2 lc rgb 'blue' title 'Control Points', 'Unit_Circ.dat' u 1:2 lc rgb 'black' title 'Unit Circle pnts', \
 './CP.dat' u 1:2 w l title ''
pause -1
