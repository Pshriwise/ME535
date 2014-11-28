

function [ctrl_cage] = arm( CPs, t, k, boxes, render, angle)

%plot the curve as well (for verification)
curve = bsplineCurve(CPs, k , t, 20); 
if boxes
plot3(curve(:,1),curve(:,2),curve(:,3),'r')
plot3(tent_pnts(:,1,1),tent_pnts(:,1,2),tent_pnts(:,1,3))
end

%get the tentacle points
tent_pnts = tentacle( CPs, k, t, boxes, 20); 

bod_connection( tent_pnts, false, angle);

%create rotation matrix (about z-axis) 
R = [ cosd(angle) -sind(angle) 0; sind(angle) cosd(angle) 0; 0 0 1];


%setup knot array
[a b c] = size(tent_pnts); 

%apply rotation to tentacle points 
for i = 1:a
    for j = 1:b 
        tent_pnts(i,j,:) = R*squeeze(tent_pnts(i,j,:));
    end
end

%add weights
weights = [ 1 sqrt(2)/2];
weights = horzcat(weights,weights,weights,weights,1);

for i = 1:a
    for j = 1:b
        tent_pntsW(i,j,:) = [squeeze(tent_pnts(i,j,:).*weights(j));weights(j)];
    end
end

circle_knots = [ 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 ];

ints = 21; 
u_vec= linspace(0,1,ints);
v_vec= linspace(0,1,ints);
surface = zeros(a,ints,c+1);
for i = 1:a
    for j = 1:ints
			surface(i,j,:) =  de_Boor(squeeze(tent_pntsW(i,:,:)),2,circle_knots,v_vec(j),-1);
            %reduce weight
            surface(i,j,:) = surface(i,j,:)./surface(i,j,end);
    end
end

ctrl_cage = tent_pnts;


if (render) 
    surf(surface(:,:,1),surface(:,:,2),surface(:,:,3))
end
