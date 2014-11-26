function [radius] = get_circle_rad(u, show)
    
    start_rad = 1;
    r_vals = [ 1; 0.95; 0.63; 0.3; 0];
    u_vals = [ 0; 0.08;0.18; 0.85; 1 ];
    k = 3;
    Data = [u_vals r_vals];
    
    [CPs, knots] = bspline_interpolate(Data,k);
    %remove superfluous
    knots = knots(2:end-1);
    
    radius = de_Boor(CPs,k,knots,u,-1);
    radius = start_rad*radius(2);
    
    if nargin < 2
        show = false; 
    end
    
    if show
        ints = 40
        for i = 1:40 
            u = (i-1)/(40-1);
            curve(i,:) = de_Boor(CPs,k,knots,u,-1);
        end
        
    figure(); 
    hold on; 
    xlabel('u');
    ylabel('r');
    title('Radial Tentacle Profile');
    
    h1 = plot(u_vals,r_vals,'square');
    h2 = plot(CPs(:,1),CPs(:,2),'blacko');
    plot(CPs(:,1),CPs(:,2),'black');
    h3 = plot(curve(:,1),curve(:,2),'r');
    legend([h1 h2 h3],'Sample Points','Control Points','Profile');
    
    end