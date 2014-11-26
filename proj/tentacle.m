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
