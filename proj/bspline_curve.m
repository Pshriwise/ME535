


function [ pnts ] = bspline_curve( CPs, k, t, tol)
%Function for returning bspline points with a faceting tolerance
%CPs - control points of the curve
%k - degree of the curve
%t - knot vector for the curve
%tol - facet tolerance for the curve 

[m,d] = size(CPs);   %get number of control points m

u = t(k);
index = 1; 
%set first point at the beginning of the curve always 
pnts(index,:) = de_Boor(CPs,k,t,u,-1);

%set the initial du value
du = (t(m)-t(k))*tol;

while true

        %find the minimum value of c2 on the interval u -> u+du; 
        min_u = u; 
        %preserve end condition
        if u+du > t(m)
            max_u = t(m);
        else
            max_u = u+du;
        end
        
        
        intervals = 15; 
        
        start = de_Boor(CPs, k , t, min_u, -1); 
        finish = de_Boor(CPs, k, t, max_u, -1);
        chord = finish-start; 
        for i = 1:intervals 
            
            test_u = min_u + i*(max_u-min_u)/intervals;
            
            
            %get the curve information
            [c c1 c2] = de_Boor_all(CPs, k, t, test_u, -1);
            
            
            err = norm((dot(c-start,chord)/dot(chord,chord))*chord);
            if i == 1
                err_max = err; 
            elseif err > err_max; 
                err_max = err; 
            end
            
            
        end
        %err_min
        %if the curvature is too high, reduce du and try again
        if (err_max > tol)
            du = du * (tol/err_max); 
        %if we've achieved the min curvature we'd like, then add the point
        %and take our step along u, then reset du
        %elseif (c2_min > tol)
        %    du = du * (c2_min/tol);
        else
            index = index+1; 
            u = max_u; 
            pnts(index,:) = de_Boor(CPs,k,t,u,-1);
            du= (t(m)-t(k))*tol;            
        end         
            
        %if we've reached the end of the curve, then exit the loop
        if u == t(m)
            break;
        end
end


