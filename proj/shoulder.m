
function shoulder_pnts = shoulder( cage, angle, rad_ints, render, fileid )
% Creates a connection from the arm to the body of the octopus based on the
% control cage of the arm surface
% cage - the control cage of the arm (used to ensure C1 continuity with the
% shoulder
% angle - angle of rotation about the z-axis (in degrees)
% rad_ints - number of radial intervals to use in the shoulder 
% render - flag for rendering of the sholder
% fileid - file id to write to for .stl conversion of surface

    
%snag the first couple control point sets
adj_surf_CPs(1:2,:,:) = cage(1:2,:,:);


%for each point, flip the second set of CPs over the first set to get the
%start of a continuout surface

[a b c] = size(adj_surf_CPs);

weights = [ 1 sqrt(2)/2];
weights = horzcat(weights,weights,weights,weights,1);

for i = 1:b
    
    vec(1,1,:) = adj_surf_CPs(2,i,1:3)-adj_surf_CPs(1,i,1:3);
    %replace the second set of points with the new ones
    adj_surf_CPs(2,i,1:3) = adj_surf_CPs(1,i,1:3) + (-1)*vec;
    
end

%add new sections for this surface 
for i = 3:13
    adj_surf_CPs(i,1:5,1:3) = adj_surf_CPs(i-1,1:5,1:3).*0.8;
    adj_surf_CPs(i,9,1:3) = adj_surf_CPs(i-1,9,1:3).*0.8;
    adj_surf_CPs(i,6:8,1) = adj_surf_CPs(i-1,6:8,1).*0.95;
    adj_surf_CPs(i,6:8,2) = adj_surf_CPs(i-1,6:8,2).*1.01;
    adj_surf_CPs(i,6:9,3) = adj_surf_CPs(i-1,6:9,3).*1.02;
    adj_surf_CPs(i,:,4) = adj_surf_CPs(i-1,:,4); %bring weights along!
end

i = i+1; 
%make sure the bottom points go to the origin 
    adj_surf_CPs(i,1:4,1:3) = adj_surf_CPs(i-1,1:4,1:3).*0; % <--
    adj_surf_CP2(i,5,1:3) = adj_surf_CPs(i-1,5,1:3).*0;
    adj_surf_CPs(i,9,1:3) = adj_surf_CPs(i-1,9,1:3).*0;
    adj_surf_CPs(i,6:8,1) = adj_surf_CPs(i-1,6:8,1).*0.95;
    adj_surf_CPs(i,6:8,2) = adj_surf_CPs(i-1,6:8,2).*1.01;
    adj_surf_CPs(i,6:9,3) = adj_surf_CPs(i-1,6:9,3).*1.02;
    adj_surf_CPs(i,:,4) = adj_surf_CPs(i-1,:,4); %bring weights along!


%create rotation matrix 
R = [ cosd(angle) -sind(angle) 0; sind(angle) cosd(angle) 0; 0 0 1];



[a b c] = size(adj_surf_CPs); 
%plot3(adj_surf_CPs(:,:,1),adj_surf_CPs(:,:,2),adj_surf_CPs(:,:,3),'o')
% %apply weights 
for i = 1:a
    for j = 1:b
        adj_surf_CPs(i,j,1:c-1) = R*squeeze(adj_surf_CPs(i,j,1:c-1));
        adj_surf_CPsW(i,j,1:c-1) = squeeze(adj_surf_CPs(i,j,1:c-1)).*adj_surf_CPs(i,j,c);
        adj_surf_CPsW(i,j,c) = adj_surf_CPs(i,j,c);
    end
end


%show the surface points for this small segment
circle_knots = [ 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 ];


v_vec = linspace(0,1,rad_ints); 
[a b c] = size(adj_surf_CPsW);
surface = zeros(a,rad_ints,c);
for i = 1:a
    for j = 1:rad_ints
        surface(i,j,:) = de_Boor(squeeze(adj_surf_CPsW(i,:,:)),2,circle_knots,v_vec(j),-1);
        %remove weights
        surface(i,j,:) = surface(i,j,:)./surface(i,j,end);
    end
end

shoulder_pnts = surface(:,:,:); 

if (render)
    tri = quadmat2tris(surface);
    trisurf(tri,surface(:,:,1),surface(:,:,2),surface(:,:,3))
    quadmat2stl(fileid, fliplr(surface(:,:,1:3)));
end