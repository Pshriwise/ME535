%script for plotting circles from 1 to Zero
function [tent_pnts, final_set_info] = tentacle( path_CPs, k, t, plot )
% Returns the control cage for an octopus tentable following a bspline
% path. 

% CPs - tentacle path control points
% k - degree of path
% t - knot vector for the path 
% plot - flag for plotting control cage 


%final set information will be returned as [center, norm, radius 0 0]
[m,d] = size(path_CPs);

if (plot)
figure(1);
hold on;
end

%set the tolerance for discretizing the arm path
tol = 0.05;

u = t(k); % set u to the beginning of the curve

index = 1;
%add the first point
center = de_Boor(path_CPs,k,t,u,-1);
    n = de_Boor_deriv(path_CPs, k, t, u, -1);
    n = n./norm(n);
    pnts = gen_circle_cps(get_circle_rad(u), center, n);
    
    if(plot)
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
    
    if(plot)
    plot3(pnts(:,1),pnts(:,2),pnts(:,3), 'black-')
    end
    
    index = index + 1; 
    tent_pnts(index,:,:)= pnts;
    
    if ( u == t(m) ) %exit loop when we get to the end of the curve
        break; 
    end

end

%return final set information for use in creating the shoulder
final_set_info = [center; n; [get_circle_rad(u) 0 0]];