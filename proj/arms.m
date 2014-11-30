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

CPs = [centers(1,:); centers(1,:)+norm_vecs(1,:); centers(1,:)+2*norm_vecs(1,:); 11 0 -4; 15 0 -15; 19 0 -10];
k = 3;
t = [ 0 0 0 0.2 0.3 1 1 1];


for i = 2:3
    if ( i == 3)
        [arm_cage, bod_conn_pnts] = arm( CPs, t, k, false, true, angles(i));   
    else
        arm( CPs, t, k, false, true, angles(i));   
    end
end


%Body CPs

CPs = [ 0 0 17; 1 0 17; 2 0 17; 7 0 12; 3 0 5; 2.592 0 1.278];

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
    for j = 1:81 
        u = (i-1)/(ints-1);
        v = (j-1)/(81-1);
      surface(i,j,:) = surf_de_Boor(CP_arrayW,p,q,tu,circle_knots,u,v);
      surface(i,j,:) = surface(i,j,:)./surface(i,j,end);  %remove weights
    end
end

surf(surface(:,:,1),surface(:,:,2),surface(:,:,3),gradient(surface(:,:,3)))



%create rotation matrix 
R = [ cosd(-45) -sind(-45) 0; sind(-45) cosd(-45) 0; 0 0 1];

%now create a triangular patch to close the body 

top_edge_points = squeeze(surface(end,1:11,1:3));


right_edge_points = horzcat(bod_conn_pnts(end,16:21,1:3),bod_conn_pnts(end,1:5,1:3));

[a b c] = size(right_edge_points); 
for i = 1:a 
    for j = 1:b 
        right_edge_points(i,j,:) = R*squeeze(right_edge_points(i,j,:));
    end
end

right_edge_points = squeeze(right_edge_points); 
left_edge_points = squeeze(horzcat(bod_conn_pnts(end, 7:11, 1:3),bod_conn_pnts(end,11:16,1:3)));
left_edge_points = flipud(left_edge_points);
%create a matrix for these values 

tri_mat = zeros(11,11,3);

tri_mat(1,:,:) = top_edge_points;
tri_mat(2:end,1,:) = left_edge_points(2:end,:);

for i = 2:10
    
    j_start = 2;
    j_end = 12-i;
    tri_mat(i,j_end,:) = right_edge_points(i,:);
    
    for j = j_start:j_end-1
            coeff = (j-j_start+1)/(j_end-j_start+1);
            tri_mat(i,j,:) = (tri_mat(i,j_end,:)-tri_mat(i,1,:))*coeff + tri_mat(i,1,:); 
            
    end
end

%triangle indices 
for i = 2:10
    for j = 2:12-i
       % tri(i-1+j-1,:) = 
    end
end


for i = 2:11
    for j = 13-i:11
        
        tri_mat(i,j,:) = [NaN NaN NaN];
        
    end
end

surf(tri_mat(:,:,1),tri_mat(:,:,2),tri_mat(:,:,3))
