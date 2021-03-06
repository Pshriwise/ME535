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
tent_pnts = zeros(ints,3,n);

for u = 0.01:1/ints:1

    center = deBoor(k,t,P,u,3);
    du = 0.0001;
    n = (1/du)*(deBoor(k,t,P,u+du,3)-deBoor(k,t,P,u,3));
    n = n./norm(n);
    pnts = circle(get_circle_rad(u), center, n);
    if(plot)
    scatter3(pnts(:,1),pnts(:,2),pnts(:,3))
    plot3(pnts(:,1),pnts(:,2),pnts(:,3), '-')
    end
    tent_pnts(i,:,:)= pnts;
end