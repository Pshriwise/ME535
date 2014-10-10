
set title 'Comparison to actual Times New Roman letter "S"'
plot 'green-timesroman-alphabet-s.jpg' binary filetype=jpg w rgbimage, 'S_curves.dat' using 1:2 w l lw 2 title 'Bezier Curves', 'CPs.dat' using 1:2 title 'Control Points', \
     'CPs.dat' using 1:2 w l lt 3 title ''
pause -1
set title 'Sheared S'
plot 'S_curves_trans.dat' using 1:2 w l title 'Normal S' , 'S_curves_shear.dat' using 1:2 w l title 'Sheared S'
pause -1
