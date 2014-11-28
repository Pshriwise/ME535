%script for creating the tentacles of the octopus

%functions in a hw directory are needed for this 
addpath('../HW5/')

clear all; 
close all;
clc;
%get the start points of the circle 
figure();
hold on; 
xlabel('x');
ylabel('y');
zlabel('z');
grid on;

body_radius = 5;
angles = linspace(0,360,9);

norm_vecs = [cosd(angles(:)) sind(angles(:)) 0*angles(:)];

centers = norm_vecs.*body_radius;

plot3(centers(:,1),centers(:,2),centers(:,3));
%path of the first arm (first two points must align with normal vector out
%of the body circle

CPs = [centers(1,:); centers(1,:)+norm_vecs(1,:); centers(1,:)+3*norm_vecs(1,:); 14 0 -9; 19 0 -19; 16 0 -5];
k = 3;
t = [ 0 0 0 0.2 0.3 1 1 1];


for i = 1:9
    arm( CPs, t, k, false, true, angles(i));   
end




%Body CPs

CPs = [ 0 0 17; 1 0 17; 2 0 17; 7 0 12; 3 0 5; 2.7502 0 1.5395];

p = 3;

tu = [ 0 0 0 0.3 0.6 1 1 1];

centers = CPs; 
centers(:,1) = 0*centers(:,1);

radii = CPs(:,1);

for i = 1:6
    CP_array(:,i,:) = gen_circle_cps(radii(i),centers(i,:),[0 0 1]);
end

[a b c] = size(CP_array);
CP_arrayW=zeros(a,b,c);
for i = 1:a
    for j = 1:b
        CP_arrayW(i,j,1:c-1) = squeeze(CP_array(i,j,1:c-1))*CP_array(i,j,c);
        CP_arrayW(i,j,c) = CP_array(i,j,c);
    end
end


q = 2;
circle_knots = [ 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 ];


ints = 20;

for i = 1:ints
    for j = 1:9 
        u = (i-1)/(ints-1);
        v = (j-1)/(9-1);
      surface(i,j,:) = surf_de_Boor(CP_arrayW,p,q,tu,circle_knots,u,v);
      surface(i,j,:) = surface(i,j,:)./surface(i,j,end);  %remove weights
    end
end

mesh(surface(:,:,1),surface(:,:,2),surface(:,:,3),gradient(surface(:,:,3)),'facealpha',0)
