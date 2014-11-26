%script for creating the tentacles of the octopus

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




