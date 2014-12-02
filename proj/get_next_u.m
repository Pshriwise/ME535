
function u = get_next_u( CPs, k, t, u, tol )
% Returns the next u-value to use on a curve for a given error tolerance

% CPs - control points of the curve (any dim)
% k - degree of the bspline curve 
% t - knot vector for the curve 
% u - paramter value for the point to be returned
% tol - maximum allowable distance for the facet to be from the curve

[m,d] = size(CPs);

%set an initial step value
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
        
        %check over this many intervals that our tolerance is satisfied
        intervals = 15; 
        
        start = de_Boor(CPs, k , t, min_u, -1); 
        finish = de_Boor(CPs, k, t, max_u, -1);
        chord = finish-start; 
        for i = 1:intervals 
            
            test_u = min_u + i*(max_u-min_u)/intervals;
            
            
            %get the curve information
            c = de_Boor(CPs, k, t, test_u, -1);
            
            %calculate the error
            err = norm((dot(c-start,chord)/dot(chord,chord))*chord);
            
            %set error if this is our first check
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
        else
            u = max_u; %found an acceptable u, return this value
            return;
        end         
            
end