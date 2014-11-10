% Script for getting a point on a Bezier Triangle Patch
clear all;

%setup matrix for CPs
degree = 4; 
P = zeros(degree,degree,3)

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

for i = 1:num_ints
    for j = 1:num_ints
            %set u,v,w values
            u = i/num_ints; v = j/num_ints; w = 1-u-v;
            %calculate the point for this u,v,w
            pnt = BezierTriPatchPnt( P, u, v, w);
            surf_pnts(i,j,:) = pnt;
    end
end


x=surf_pnts(:,:,1);
y=surf_pnts(:,:,2); 
z=surf_pnts(:,:,3);


figure(2); 
clf;
surf(x,y,z);
            


