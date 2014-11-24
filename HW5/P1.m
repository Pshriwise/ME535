
close all;
clear all;

%initialize input data
D=[1 -2; 0 0; 3 4; -1 4; -4 0; -4 -3; -5 -2];
k=3;
n=5;



%plot the data
figure();
hold on; 
plot( D(:,1),D(:,2),'x')


%run interpolation
[CPs, U] = bspline_interpolate(D,k); 

%plot the control points
plot(CPs(:,1),CPs(:,2),'go')

%remove superfluous knots
U = U(2:end-1);

%plot the curve
curve = bsplineCurve(CPs,k,U,40);

plot(curve(:,1),curve(:,2),'r');



%now do the approximation
[CPs, U] = bspline_approximate(D,k,5);
%remove superfluous knots
U = U(2:end-1);
curve = bsplineCurve(CPs,3,U,40);
plot(curve(:,1),curve(:,2),'black');

