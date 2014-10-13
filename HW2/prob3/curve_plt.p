

set key bottom right
plot "curve2.dat" using 2:3 title  't [0,0.75]' , "curve1.dat" using 2:3 title 't [0.75,1]', "orig_curve.dat" using 2:3 w l title 'Original Curve'
pause -1
