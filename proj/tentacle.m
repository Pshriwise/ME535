%script for plotting circles from 1 to Zero
function [tent_pnts] = tentacle( path_CPs, k, t, plot, ints )
% CPs - tentacle path control points
% k - degree of path
% t - knot vector for the path 

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
tent_pnts = zeros(ints,n*4,3);
u_min = 0.01;
for i = 1:ints

    u = u_min + i*((1-u_min)/ints);
    center = de_Boor(path_CPs,k,t,u,-1);
    du = 0.0001;
    n = de_Boor_deriv(path_CPs, k, t, u, -1)
    n = n./norm(n);
    pnts = circle(get_circle_rad(u), center, n);
    if(plot)
    scatter3(pnts(:,1),pnts(:,2),pnts(:,3))
    plot3(pnts(:,1),pnts(:,2),pnts(:,3), '-')
    end
    tent_pnts(i,:,:)= pnts;
end