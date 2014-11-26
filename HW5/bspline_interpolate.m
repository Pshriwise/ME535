

function [ P, U ] = bspline_interpolate( D, k )


[n m] = size(D);

us = chord_len_knots(D);

U = get_knot_vector(us, k, -1); 

%add superfluous knots 
U = horzcat(0,U,1);


M = zeros(n,n); 


for i = 2:n-1
     for j = 1:n
         M(i,j) = bsplineN(us(i), U, j-1, k);
     end
end
 
M(1,1) = 1; 
M(n,n) = 1; 


P = inv(M)*D;
        