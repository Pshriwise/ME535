%script for creating the tentacles of the octopus

clear all; 
close all;
clc;
%get the start points of the circle 

body_radius = 5;
angles = linspace(0,360,8);

norm_vecs = [cosd(angles(:)) sind(angles(:)) 0*angles(:)];

centers = norm_vecs.*body_radius;

plot3(centers(:,1),centers(:,2),centers(:,3));
%path of the first arm (first two points must align with normal vector out
%of the body circle
CP1 = [centers(1,:); centers(1,:)+2*norm_vecs(1,:); 14 7 9; 19 14 19; 22 12 21];
k = 3;
t = [ 0 0 0 0.5 1 1 1];

tentacle( CP1, k, t, true, 60); 
%curve = bsplineCurve(CP1, k , t, 20); 

CP2 = [centers(2,:); centers(2,:)+2*norm_vecs(2,:); 19 10 11; 19 20 19; 15 18 51];
k = 3;
t = [ 0 0 0 0.5 1 1 1];

tentacle( CP2, k, t, true, 60 ); 

CP3 = [centers(3,:); centers(3,:)+2*norm_vecs(3,:); 19 10 -5; 19 20 -19; 15 18 -51];
k = 3;
t = [ 0 0 0 0.5 1 1 1];

tentacle( CP3, k, t, true, 60 ); 

xlabel('x');
ylabel('y');
zlabel('z');
grid on;