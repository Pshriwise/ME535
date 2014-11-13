% Script for getting a point on a Bezier Triangle Patch
clear all;

%setup matrix for CPs
degree = 3; 
P = zeros(degree,degree,1)

%initialize CPs
P(:,:,1) = [ 298 177 108; 207 127 0; 152 0 0];


%setup our intervals
num_ints = 10;

values = zeros(1, num_ints*num_ints*num_ints);
surf_pnts = zeros(3,num_ints);

umin = 2; umax = 4;
vmin = 2; vmax=3;


us=zeros(num_ints,num_ints,1);
vs=zeros(num_ints,num_ints,1);

for i = 0:num_ints
    for j = 0:i
            %set u,v,w values
            a = i/num_ints; b = j/num_ints;
            u = a-b; v = 1-a; w = b;   
            us(i+1,j+1) = u;
            vs(i+1,j+1) = v;
            %calculate the point for this u,v,w
            pnt = BezierTriPatchPnt( P, u, v, w );           
            surf_pnts(i+1,j+1,:) = pnt;
    end
end

        
values=surf_pnts(:,:,1);
us = us(:,:,1);
vs = vs(:,:,1);

values(values==0) = NaN;
us(1,1) = 0; 
a(eye(size(a))~=0)=0;
vs(vs==0) = NaN;
vs(end,:) = 0;

figure(2); 
clf;
surf(us,vs,values);
            

hold on;
clear all;

P(:,:,1) = [ 244 158 108; 268 177 0; 298 0 0];

%setup our intervals
num_ints = 10;

values = zeros(1, num_ints*num_ints*num_ints);
surf_pnts = zeros(3,num_ints);

umin = 2; umax = 4;
vmin = 2; vmax=3;


us=zeros(num_ints,num_ints,1);
vs=zeros(num_ints,num_ints,1);

for i = 0:num_ints
    for j = 0:i
            %set u,v,w values
            a = i/num_ints; b = j/num_ints;
            u = a-b; v = 1-a; w = b;   
            us(i+1,j+1) = u;
            vs(i+1,j+1) = v;
            %calculate the point for this u,v,w
            pnt = BezierTriPatchPnt( P, u, v, w );           
            surf_pnts(i+1,j+1,:) = pnt;
    end
end

        
values=surf_pnts(:,:,1);
us = us(:,:,1);
vs = vs(:,:,1);

values(values==0) = NaN;
us(1,1) = 0; 
a(eye(size(a))~=0)=0;
vs(vs==0) = NaN;
vs(end,:) = 0;

%figure(2); 
%clf;
surf(us,vs,values);
