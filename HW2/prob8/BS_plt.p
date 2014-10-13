#Function for plotting x,y coords as labels
get_point(x,y,z) = sprintf('(%.4f,%.4f,%.4f)', x, y, z)

set title 'Cubic B-Spline'
splot './BSpline.dat' u 1:2:3 w l title 'Bspline curve', './CP.dat' u 1:2:3 lc rgb 'blue' title 'Control Points', \
'pnt.dat' using ($1+0.3):($2-0.2):($3-10):(get_point($1,$2,$3)) with labels title '', 'pnt.dat' using 1:2:3 title 'Value at t=1.5'
pause -1
