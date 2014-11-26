

function arm( CPs, t, k, boxes, render)


%get the tentacle points
tent_pnts = tentacle( CPs, k, t, boxes, 20); 
%plot the curve as well (for verification)
curve = bsplineCurve(CPs, k , t, 20); 
if boxes
plot3(curve(:,1),curve(:,2),curve(:,3),'r')
plot3(tent_pnts(:,1,1),tent_pnts(:,1,2),tent_pnts(:,1,3))
end
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


if (render) 
    surf(surface(:,:,1),surface(:,:,2),surface(:,:,3))
end
