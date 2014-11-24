
function U = get_knot_vector(us, k)

[b n] = size(us);

U = zeros(1,n+k-1); 

%Pin curve to beginning and ending control points
U(1:k) = 0; 
U(end-(k-1):end) = 1; 

for i = 1:n-k-1
    
    for j=i+1:i+k
        U(i+k) = U(i+k) + us(j);
    end
    
    U(i+k) = U(i+k)/k;
    
end

    
    
    
    