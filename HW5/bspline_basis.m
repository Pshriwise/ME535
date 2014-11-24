

function N = bspline_basis( u, U, i, k)


switch k > 0
    case false
        if ( U(i) <= u && U(i+1) > u )
            N = 1;
        else
            N = 0;
        end
        return
    case true
        bs1 = bspline_basis(u, U, i, k-1) ;
        
        bs2 = bspline_basis(u, U, i+1, k-1);
        
        if ( 0 == bs1)
            coeff1 = 0;
        elseif ( 0 == (U(i+k) - U(i)))
            coeff1 = 0;
        else
            coeff1 = (u - U(i)) / (U(i+k) - U(i));
        end
        
        if ( 0 == bs2 )
            coeff2 = 0;
        elseif ( 0 == (U(i+k+1) - U(i+1)))
            coeff2 = 0;
        else
            coeff2 = (U(i+k+1) - u )/ (U(i+k+1)-U(i+1));
        end
        
        N = coeff1 * bs1 +  coeff2 * bs2;
        return
end
        
        
    