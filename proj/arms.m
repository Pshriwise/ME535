%script for creating the tentacles of the octopus

%functions in a hw directory are needed for this 
addpath('../HW5/')

clear all; 
close all;
clc;

%open a file for the triangles
fid = fopen('octo.stl','w');

%create a solid header
startsolidstl(fid, 'octo');

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

%plot3(centers(:,1),centers(:,2),centers(:,3));
%path of the first arm (first two points must align with normal vector out
%of the body circle

CPs = [centers(1,:); centers(1,:)+norm_vecs(1,:); centers(1,:)+2*norm_vecs(1,:); 11 0 -4; 15 0 -15; 19 0 -10];
k = 3;
t = [ 0 0 0 0.2 0.3 1 1 1];

%this value should always be odd and (radial_intervals-1)%4 == 0
radial_intervals = 21;

for i = 1:8
    if ( i == 3)
        [arm_cage, bod_conn_pnts] = arm( CPs, t, k, false, true, angles(i), radial_intervals, fid);   
    else
        arm( CPs, t, k, false, true, angles(i), radial_intervals, fid);   
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
rad_ints = 4*(radial_intervals-1)+1;

for i = 1:ints
    for j = 1:rad_ints
        u = (i-1)/(ints-1);
        v = (j-1)/(rad_ints-1);
      surface(i,j,:) = surf_de_Boor(CP_arrayW,p,q,tu,circle_knots,u,v);
      surface(i,j,:) = surface(i,j,:)./surface(i,j,end);  %remove weights
    end
end

tri = quadmat2tris(surface);
trisurf(tri,surface(:,:,1),surface(:,:,2),surface(:,:,3),gradient(surface(:,:,3)))
quadmat2stl(fid, surface(:,:,1:3));
clear tri;


%create rotation matrix 
R = [ cosd(-45) -sind(-45) 0; sind(-45) cosd(-45) 0; 0 0 1];

%now create a triangular patch to close the body 

armpit_intervals = 1+(radial_intervals-1)/2;
top_edge_points = squeeze(surface(end,1:armpit_intervals,1:3));

re_indices = [ 1+(radial_intervals-1)*3/4 radial_intervals 1 (radial_intervals-1)/4];
right_edge_points = horzcat(bod_conn_pnts(end,re_indices(1):re_indices(2),1:3),bod_conn_pnts(end,re_indices(3):re_indices(4),1:3));

[a b c] = size(right_edge_points); 
for i = 1:a 
    for j = 1:b 
        right_edge_points(i,j,:) = R*squeeze(right_edge_points(i,j,:));
    end
end

right_edge_points = squeeze(right_edge_points); 

le_indices = [ 1+(radial_intervals-1)/4 1+(radial_intervals-1)*(3/4)];
left_edge_points = squeeze(horzcat(bod_conn_pnts(end,le_indices(1):le_indices(2),1:3)));
left_edge_points = flipud(left_edge_points);
%create a matrix for these values 

tri_mat = zeros(armpit_intervals,armpit_intervals,3);

tri_mat(1,:,:) = top_edge_points;
tri_mat(2:end,1,:) = left_edge_points(2:end,:);

for i = 2:10
    
    j_start = 2;
    j_end = armpit_intervals+1-i;
    tri_mat(i,j_end,:) = right_edge_points(i,:);
    
    for j = j_start:j_end-1
            coeff = (j-j_start+1)/(j_end-j_start+1);
            tri_mat(i,j,:) = (tri_mat(i,j_end,:)-tri_mat(i,1,:))*coeff + tri_mat(i,1,:); 
            
    end
end

%triangle indices 
num_tris=0;

for i = 1:armpit_intervals-1
    %create a triangle for each new row
    num_tris= num_tris+1;
    tri(num_tris,:) = [ (i)*armpit_intervals + 1 (i-1)*armpit_intervals + 1 (i-1)*armpit_intervals + (1+1) ]; 
    for j = 2:armpit_intervals-i
        num_tris = num_tris +1;
        tri(num_tris,:) = [ (i)*armpit_intervals + j (i-1)*armpit_intervals + j (i)*armpit_intervals + (j-1)];
        
        num_tris = num_tris +1;
        tri(num_tris,:) = [ (i)*armpit_intervals + j (i-1)*armpit_intervals + j (i-1)*armpit_intervals + (j+1)];
        
       % tri(i-1+j-1,:) = 
    end
end


for i = 2:armpit_intervals
    for j = armpit_intervals+2-i:armpit_intervals
        
        tri_mat(i,j,:) = [NaN NaN NaN];
        
    end
end

for k = 1:8
%create rotation matrix 
R = [ cosd(angles(k)) -sind(angles(k)) 0; sind(angles(k)) cosd(angles(k)) 0; 0 0 1];

%rotate and plot
for i = 1:armpit_intervals
    for j = 1:armpit_intervals
        tri_mat(i,j,:) = R*squeeze(tri_mat(i,j,:));
    end
end

        
        
trisurf(tri,tri_mat(:,:,1),tri_mat(:,:,2),tri_mat(:,:,3))
trimat2stl(fid, tri_mat);
end


endsolidstl(fid, 'octo')
fclose(fid);
