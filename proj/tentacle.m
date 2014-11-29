%script for plotting circles from 1 to Zero
function [tent_pnts] = tentacle( path_CPs, k, t, plot, ints )
% CPs - tentacle path control points
% k - degree of path
% t - knot vector for the path 

[m,d] = size(path_CPs);

if (plot)
figure(1);
hold on;
end
%arm path
%P = [ 1 2 5; 3 6 8; 5 3 9; 10 8 10];
%t = [ 0 0 0 1 1 1];
%k = 3;
n = 20;
% there should be ints sets of points each having n points in 4 sections
% and in 3 dimesnions
tol = 0.2;
index = 1;
u = t(k);

%add the first point
center = de_Boor(path_CPs,k,t,u,-1);
    n = de_Boor_deriv(path_CPs, k, t, u, -1);
    n = n./norm(n);
    pnts = gen_circle_cps(get_circle_rad(u), center, n);
    %apply weights
%    w = [ 1 sqrt(2)/2 1 sqrt(2)/2 1 sqrt(2)/2 1 sqrt(2)/2 1];
%    for i = 1:9
%        pnts(i,:) = pnts(i,:)*w(i);
%    end
    
    if(plot)
    %scatter3(pnts(:,1),pnts(:,2),pnts(:,3))
    plot3(pnts(:,1),pnts(:,2),pnts(:,3), 'black-')
    end
    tent_pnts(index,:,:)= pnts;

    
%now add the rest 
while true

    u = get_next_u( path_CPs,k,t,u, tol );
    center = de_Boor(path_CPs,k,t,u,-1);
    n = de_Boor_deriv(path_CPs, k, t, u, -1);
    n = n./norm(n);
    pnts = gen_circle_cps(get_circle_rad(u), center, n);
    %apply weights
%    w = [ 1 sqrt(2)/2 1 sqrt(2)/2 1 sqrt(2)/2 1 sqrt(2)/2 1];
 %   for i = 1:9
  %      pnts(i,:) = pnts(i,:)*w(i);
   % end
    if(plot)
    %scatter3(pnts(:,1),pnts(:,2),pnts(:,3))
    plot3(pnts(:,1),pnts(:,2),pnts(:,3), 'black-')
    end
    index = index + 1; 
    tent_pnts(index,:,:)= pnts;
    
    if ( u == t(m) )
        break; 
    end
   
    
end

%add a cap to the tentacle

%grab the final set of tentacle points 
last_set = tent_pnts(end,:,:);

%and the final normal vector, center and radius 
last_norm = n; last_center = center; last_rad = get_circle_rad(u); 

%the cap's first set will be the tentacle's last set
cap_CPs(1,:,:) = last_set;


%this cap will go the length of one unit in the plot and close 
%need three co-linear control points at the end to close the tentacle with 
%C1 continuity

new_center = last_center + 0.5*n; 

%the first control point will match last_radius
%cap_CPs(2,:,:) = gen_circle_cps(last_rad, new_center, n);

%now reduce the radius to half its original value and repeat
last_rad = last_rad*0.5;
cap_CPs(2,:,:) = gen_circle_cps(last_rad, new_center, n);

%finally reduce the radius to zero
cap_CPs(3,:,:) = gen_circle_cps(0, new_center, n);


%now setup the knots and degrees for each direction 
p = 2; q = 2;
uknots = [ 0 0 1 1]; 
vknots = [ 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 ];

[a b c] = size(cap_CPs);
%apply weights 
for i = 1:a 
    for j = 1:b
        cap_CPsW(i,j,1:3) = cap_CPs(i,j,1:3).*cap_CPs(i,j,end); 
        cap_CPsW(i,j,4) = cap_CPs(i,j,end); 
    end
end


%plot the cap as a surface 
uints = 20; vints = 21; 
u = linspace(0,1,uints); 
v = linspace(0,1,vints);
for i = 1:uints
    for j = 1:vints
        surf_pnts(i,j,:) = surf_de_Boor(cap_CPsW,q,p,vknots,uknots,v(j),u(i));
        %remove weight
        surf_pnts(i,j,1:3) = surf_pnts(i,j,1:3)./surf_pnts(i,j,end); 
    end
end


surf(surf_pnts(:,:,1),surf_pnts(:,:,2),surf_pnts(:,:,3))



