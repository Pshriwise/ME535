
function u = get_next_u( CPs, k, t, u, tol )


[m,d] = size(CPs);

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
            c = de_Boor(CPs, k, t, test_u, -1);
            
            
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
        else
            u = max_u; 
            return;
        end         
            
end