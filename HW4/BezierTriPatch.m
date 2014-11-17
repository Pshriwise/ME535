% Script for getting a point on a Bezier Triangle Patch
clear all;
clc
%setup matrix for CPs
degree = 4; 
P = zeros(degree,degree,3);

%initialize CPs
P(:,:,1) = [ 4 2 1 0; 4 2 1 0; 3 2 0 0; 2 0 0 0];
P(:,:,2) = [ 1 0 0 0; 2 2 1 0; 3 3 0 0; 4 0 0 0 ];
P(:,:,3) = [ 3 2 1 1; 3 2 1 0; 2 2 0 0; 3 0 0 0 ];

%setup our intervals
num_ints = 20;

x = zeros( num_ints*num_ints*num_ints);
y = zeros( num_ints*num_ints*num_ints);
z = zeros( num_ints*num_ints*num_ints);

surf_pnts = zeros(num_ints,num_ints,3);

for i = 0:num_ints
    for j = 0:i
            %set u,v,w values
            a = i/num_ints; b = j/num_ints; 
            u = a-b; v = 1-a; w = b;
            %calculate the point for this u,v,w
            pnt = BezierTriPatchPnt( P, u, v, w);
            surf_pnts(i+1,j+1,:) = pnt;
    end
end


surf_pnts(surf_pnts==0) = NaN;

x=surf_pnts(:,:,1);
y=surf_pnts(:,:,2); 
z=surf_pnts(:,:,3);



figure(2); 
clf;
surf(x,y,z);
xlabel('x');
ylabel('y');
zlabel('z');
title('Problem 1 Cubic Trianglular Patch');
            


