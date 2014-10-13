set xrange [-0.5:3.5]
plot './BSpline.dat' u 1:2 w l title 'Bspline curve', './CP.dat' u 1:2 lc rgb 'blue' title 'Control Points', './CP.dat' u 1:2 w l lc rgb 'blue' title ''
pause -1
set title 'Cubic B-Spline'
set style line 2 lc rgb 'black' lt 1 lw 2
set style fill transparent solid 0.5 border 2 
plot './BSpline.dat' u 1:2 w l title 'Bspline curve', './CP.dat' u 1:2 lc rgb 'blue' title 'Control Points', './CP.dat' u 1:2 w l lc rgb 'blue' title '', \
'./boxes.dat' with filledcurves lc rgb 'gray30'
pause -1
