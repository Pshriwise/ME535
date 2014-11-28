
function bod_connection( cage, flip, angle )


    
%snag the first couple control point sets
adj_surf_CPs(1:2,:,:) = cage(1:2,:,:);

%some of these need to be flipped depending on the orientation of the
%control points
if flip 
    adj_surf_CPs(1,:,:) = flipud(squeeze(adj_surf_CPs(1,:,:)));
    adj_surf_CPs(2,:,:) = flipud(squeeze(adj_surf_CPs(2,:,:)));
end

%for each point, flip the second set of CPs over the first set to get the
%start of a continuout surface

[a b c] = size(adj_surf_CPs);

weights = [ 1 sqrt(2)/2];
weights = horzcat(weights,weights,weights,weights,1);

for i = 1:b
    
    vec(1,1,:) = adj_surf_CPs(2,i,:)-adj_surf_CPs(1,i,:);
    %replace the second set of points with the new ones
    adj_surf_CPs(2,i,:) = adj_surf_CPs(1,i,:) + (-1)*vec;
    
end

%add new sections for this surface 
for i = 3:13
    adj_surf_CPs(i,1:5,:) = adj_surf_CPs(i-1,1:5,:).*0.8;
    adj_surf_CPs(i,9,:) = adj_surf_CPs(i-1,9,:).*0.8;
    adj_surf_CPs(i,6:8,1) = adj_surf_CPs(i-1,6:8,1).*0.95;
    adj_surf_CPs(i,6:8,2) = adj_surf_CPs(i-1,6:8,2).*1.02;
    adj_surf_CPs(i,6:9,3) = adj_surf_CPs(i-1,6:9,3).*1.04;
end


%create rotation matrix 
R = [ cosd(angle) -sind(angle) 0; sind(angle) cosd(angle) 0; 0 0 1];




%plot3(adj_surf_CPs(:,:,1),adj_surf_CPs(:,:,2),adj_surf_CPs(:,:,3),'o')
%apply weights 
for i = 1:13
    for j = 1:b
        adj_surf_CPs(i,j,:) = R*squeeze(adj_surf_CPs(i,j,:));
        adj_surf_CPsW(i,j,:) = [squeeze(adj_surf_CPs(i,j,:).*weights(j));weights(j)];
    end
end


%show the surface points for this small segment
circle_knots = [ 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 ];

ints = 21;
v_vec = linspace(0,1,ints); 
[a b c] = size(adj_surf_CPsW);
surface = zeros(a,ints,c);
for i = 1:a
    for j = 1:ints
        surface(i,j,:) = de_Boor(squeeze(adj_surf_CPsW(i,:,:)),2,circle_knots,v_vec(j),-1);
        %remove weights
        surface(i,j,:) = surface(i,j,:)./surface(i,j,end);
    end
end


surf(surface(:,:,1),surface(:,:,2),surface(:,:,3))