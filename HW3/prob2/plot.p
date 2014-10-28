
set xlabel 'x'
set ylabel 'y'
set zlabel 'z'
set view equal xyz 
set title 'NURBS representation of cylindrical surface'
splot 'NURBS_data.dat' u 1:2:3 title ''
pause -1
set terminal 'png'
set output 'NURBS_cyl.png'
replot 
set terminal 'wxt'

set title 'Coons patch of the cylindrical surface'
splot 'Coons_data.dat' u 1:2:3 title '' lt rgb 'blue'
pause -1
set terminal 'png'
set output 'Coons_cyl.png'
replot 
set terminal 'wxt'

set title 'Bezier bicubic patch of the cylindrical surface'
splot 'bicubic_data.dat' u 1:2:3 title '' lt rgb 'green'
pause -1
set terminal 'png'
set output 'BBC_cyl.png'
replot 
set terminal 'wxt'

set title 'Ferguson patch of the cylindrical surface'
splot 'Ferg_data.dat' u 1:2:3 title '' lt rgb 'violet'
pause -1
set terminal 'png'
set output 'Ferg_cyl.png'
replot 
set terminal 'wxt'
