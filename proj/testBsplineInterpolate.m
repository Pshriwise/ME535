
% input data point, order of the curve
% D=[0 0; 3 4; -1 4; -4 0; -4 -3]; % data points
clear all; 

D=[4 1; 5 2; 6 2;8 2;9 3];
k=4;
n=5;

% compute Bspline control points
[P, knots] = BsplineInterpolate(D,k,n);
P 
%knots = [ 0 0 0 0 1 1 1 1];
%k
% plot data points
plot(D(:,1), D(:,2),'rs');
hold on;

%define display configuration
dn = 40; % # of points on the B-spline curve
%do calculation
Q = bsplineCurve(P, k, knots, dn);


%do plot of control polygon
plot(P(:,1),P(:,2),'m-o');
hold on;
%do plot of b-spline curve
plot(Q(:,1),Q(:,2));
title('B-spline Curve');
grid on;
hold on;
