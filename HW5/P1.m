
close all;
clear all;

%initialize input data
D=[4 1; 5 2; 6 2;8 2;9 3];
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






