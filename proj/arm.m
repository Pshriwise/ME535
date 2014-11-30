

function [ctrl_cage, bod_conn_pnts] = arm( CPs, t, k, boxes, render, angle, rad_ints, fileid)

%plot the curve as well (for verification)
curve = bsplineCurve(CPs, k , t, 20); 
if boxes
plot3(curve(:,1),curve(:,2),curve(:,3),'r')
plot3(tent_pnts(:,1,1),tent_pnts(:,1,2),tent_pnts(:,1,3))
end

%create rotation matrix (about z-axis) 
R = [ cosd(angle) -sind(angle) 0; sind(angle) cosd(angle) 0; 0 0 1];

%get the tentacle points
[tent_pnts final_set_info] = tentacle( CPs, k, t, boxes, 20); 

%create a cap for the tentacle 
%grab the final set of tentacle points 
last_set = tent_pnts(end,:,:);

%and the final normal vector, center and radius 
last_norm = final_set_info(2,:); last_center = final_set_info(1,:); last_rad = final_set_info(3,1); 

%the cap's first set will be the tentacle's last set
cap_CPs(1,:,:) = last_set;


%this cap will go the length of one unit in the plot and close 
%need three co-linear control points at the end to close the tentacle with 
%C1 continuity

new_center = last_center + 0.5*last_norm; 

%the first control point will match last_radius
%cap_CPs(2,:,:) = gen_circle_cps(last_rad, new_center, n);

%now reduce the radius to half its original value and repeat
last_rad = last_rad*0.5;
cap_CPs(2,:,:) = gen_circle_cps(last_rad, new_center, last_norm);

%finally reduce the radius to zero
cap_CPs(3,:,:) = gen_circle_cps(0, new_center, last_norm);


%now setup the knots and degrees for each direction 
p = 2; q = 2;
uknots = [ 0 0 1 1]; 
vknots = [ 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 ];

[a b c] = size(cap_CPs);
%apply weights 
for i = 1:a 
    for j = 1:b
        cap_CPsW(i,j,1:3) = (R*squeeze(cap_CPs(i,j,1:3))).*cap_CPs(i,j,end); 
        cap_CPsW(i,j,4) = cap_CPs(i,j,end); 
    end
end


%plot the cap as a surface 
uints = 20; 
u = linspace(0,1,uints); 
v = linspace(0,1,rad_ints);
for i = 1:uints
    for j = 1:rad_ints
        surf_pnts(i,j,:) = surf_de_Boor(cap_CPsW,q,p,vknots,uknots,v(j),u(i));
        %remove weight
        surf_pnts(i,j,1:3) = surf_pnts(i,j,1:3)./surf_pnts(i,j,end); 
    end
end


%make the connection for the arm to the body
bod_conn_pnts = bod_connection( tent_pnts, false, angle, rad_ints, render, fileid);



%setup knot array
[a b c] = size(tent_pnts); 

%apply rotation to tentacle points 
for i = 1:a
    for j = 1:b 
        tent_pnts(i,j,1:c-1) = R*squeeze(tent_pnts(i,j,1:c-1));
    end
end

%add weights
 
for i = 1:a
    for j = 1:b
        tent_pntsW(i,j,1:c-1) = squeeze(tent_pnts(i,j,1:3)).* tent_pnts(i,j,end);
        tent_pntsW(i,j,c) = tent_pnts(i,j,c);
    end
end

circle_knots = [ 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 ];

 
v_vec= linspace(0,1,rad_ints);
surface = zeros(a,rad_ints,c);
for i = 1:a
    for j = 1:rad_ints
			surface(i,j,:) =  de_Boor(squeeze(tent_pntsW(i,:,:)),2,circle_knots,v_vec(j),-1);
            %reduce weight
            surface(i,j,:) = surface(i,j,:)./surface(i,j,end);
    end
end

ctrl_cage = tent_pnts;



%concatenate arm surface points
full_arm = [surface; surf_pnts];


if(render)
    tri = quadmat2tris(surface);
    trisurf(tri,surface(:,:,1),surface(:,:,2),surface(:,:,3))
    quadmat2stl(fileid, surface(:,:,1:3));
    tri = quadmat2tris(surf_pnts);
    trisurf(tri,surf_pnts(:,:,1),surf_pnts(:,:,2),surf_pnts(:,:,3))
    quadmat2stl(fileid, surf_pnts(:,:,1:3));

end
    