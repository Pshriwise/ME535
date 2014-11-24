

function [ P, U ] = bspline_approximate( D, k, m )


[n dim] = size(D);

us = chord_len_knots(D);

U = get_knot_vector(us, k, m); 

%add superfluous knots 
U = horzcat(0,U,1);


M = zeros(n,m); 


for i = 2:n-1
     for j = 1:m
         M(i,j) = bsplineN(us(i), U, j-1, k);
     end
end
 
M(1,1) = 1; 
M(n,m) = 1; 

% approximate for as many dimensions are in the problem 
MT = transpose(M);
MT

MMT = MT*M;
IMMT = inv(MMT);


for i = 1:dim
    
    MTD = (MT*D(:,i));
    P(:,i)= inv(MMT)*MTD;
    
end

%P = inv(M)*D;
        