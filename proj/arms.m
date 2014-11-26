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
CP1 = [centers(1,:); centers(1,:)+norm_vecs(1,:); centers(1,:)+3*norm_vecs(1,:); 14 0 9; 19 0 19; 16 0 21];
k = 3;
t = [ 0 0 0 0.2 0.3 1 1 1];

arm( CP1, t, k, false,true);   
 
CP2 = [centers(2,:); centers(2,:)+norm_vecs(2,:); centers(2,:)+3*norm_vecs(2,:); 10 15 11; 19 20 19; 15 18 51];
k = 3;
t = [ 0 0 0 0.25 0.75 1 1 1];
 
arm(CP2,t,k, false,true);

CP3 = [centers(3,:); centers(3,:)+norm_vecs(3,:); centers(3,:)+3*norm_vecs(3,:); 10 15 -5; 19 20 -19; 15 10 -51];
k = 3;
t = [ 0 0 0 0.5 1 1 1];

arm(CP3,t,k,false,true);

CP4 = [centers(4,:); centers(4,:)+norm_vecs(4,:); centers(4,:)+3*norm_vecs(4,:); -8 5 -5; -10 20 -12; -20 14 -30];
k = 3;
t = [ 0 0 0 0.5 1 1 1]; 
 
arm(CP4,t,k,false,true);


CP5 = [centers(5,:); centers(5,:)+norm_vecs(5,:); centers(5,:)+3*norm_vecs(5,:); -8 5 -5; -10 10 -12; -20 12 -30];
k = 3;
t = [ 0 0 0 0.5 1 1 1]; 
 
arm(CP5,t,k,false,true);