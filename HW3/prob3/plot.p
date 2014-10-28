


set xlabel 'x'
set ylabel 'y'
set zlabel 'z' 
set title 'B-spline surface' 
splot 'data.dat' u 1:2:3 lt rgb 'blue' title ''
pause -1

set terminal 'png'
set output 'BSpline_surf.png'
replot 
