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


body_radius = 3;
angles = linspace(0,360,8);

norm_vecs = [cosd(angles(:)) sind(angles(:)) 0*angles(:)];

centers = norm_vecs.*body_radius;

plot3(centers(:,1),centers(:,2),centers(:,3));
%path of the first arm (first two points must align with normal vector out
%of the body circle
CP1 = [centers(1,:); centers(1,:)+norm_vecs(1,:); centers(1,:)+3*norm_vecs(1,:); 14 7 9; 19 14 19; 22 12 21];
k = 3;
t = [ 0 0 0 0.5 1 1 1];

%get the tentacle points
tent_pnts = tentacle( CP1, k, t, true, 20); 
%plot the curve as well (for verification)
curve = bsplineCurve(CP1, k , t, 20); 
plot3(curve(:,1),curve(:,2),curve(:,3),'r')

%setup knot array
[a b c] = size(tent_pnts); 


circle_knots = [ 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 ];

ints = 20; 
u_vec= linspace(0,1,20);
v_vec= linspace(0,1,20);
surface = zeros(a,ints,3);
for i = 1:a
    for j = 1:ints
			surface(i,j,:) = de_Boor(squeeze(tent_pnts(i,:,:)),2,circle_knots,v_vec(j),-1);
    end
end

surf(surface(:,:,1),surface(:,:,2),surface(:,:,3))
   
 
 CP2 = [centers(2,:); centers(2,:)+norm_vecs(2,:); centers(2,:)+3*norm_vecs(2,:); 19 10 11; 19 20 19; 15 18 51];
 k = 3;
 t = [ 0 0 0 0.25 0.75 1 1 1];
 
 tent_pnts = tentacle( CP2, k, t, true, 20 ); 
 curve = bsplineCurve(CP2, k , t, 20); 
 
 plot3(curve(:,1),curve(:,2),curve(:,3),'r')

[a b c] = size(tent_pnts); 
surface = zeros(a,ints,3);
for i = 1:a
    for j = 1:ints
			surface(i,j,:) = de_Boor(squeeze(tent_pnts(i,:,:)),2,circle_knots,v_vec(j),-1);
    end
end

surf(surface(:,:,1),surface(:,:,2),surface(:,:,3))
 
 CP3 = [centers(3,:); centers(3,:)+norm_vecs(3,:); centers(3,:)+3*norm_vecs(3,:); 19 10 -5; 19 20 -19; 15 10 -51];
 k = 3;
 t = [ 0 0 0 0.5 1 1 1];
 
 tent_pnts = tentacle( CP3, k, t, true, 20 ); 
 curve = bsplineCurve(CP3, k , t, 20); 
 
 plot3(curve(:,1),curve(:,2),curve(:,3),'r')
 
[a b c] = size(tent_pnts); 
surface = zeros(a,ints,3);
for i = 1:a
    for j = 1:ints
			surface(i,j,:) = de_Boor(squeeze(tent_pnts(i,:,:)),2,circle_knots,v_vec(j),-1);
    end
end

surf(surface(:,:,1),surface(:,:,2),surface(:,:,3))

 CP4 = [centers(4,:); centers(4,:)+norm_vecs(4,:); centers(4,:)+3*norm_vecs(4,:); -8 5 -5; -10 20 -12; -20 14 -30];
 k = 3;
 t = [ 0 0 0 0.5 1 1 1];
 
 tent_pnts = tentacle( CP4, k, t, true, 20 ); 
 curve = bsplineCurve(CP4, k , t, 20); 
 
 plot3(curve(:,1),curve(:,2),curve(:,3),'r')
 
[a b c] = size(tent_pnts); 
surface = zeros(a,ints,3);
for i = 1:a
    for j = 1:ints
			surface(i,j,:) = de_Boor(squeeze(tent_pnts(i,:,:)),2,circle_knots,v_vec(j),-1);
    end
end

surf(surface(:,:,1),surface(:,:,2),surface(:,:,3))
