
set xlabel 'x'
set ylabel 'y'
set zlabel 'z'
set title 'Coons Surface between circular arcs'
set view equal xyz
splot 'data.dat' u 1:2:3
pause -1
set terminal 'png'
set output 'Coons_surface.png'
replot
