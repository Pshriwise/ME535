function pnt = BezierTriPatchPnt(P, u, v, w)

[rows, cols, dim] = size(P);

if rows ~= cols
   print "Not a valid matrix for this function";
   return;
end

while rows ~= 1    
    
    %setup the new P matrix
    P_new = zeros(rows-1, cols-1, dim);
    for i=1:rows-1
        for j=1:rows-i
            for k = 1:dim
                k
                P_new(i,j,k) = u*P(i,j,k)+v*P(i+1,j,k)+w*P(i,j+1,k);            
            end
        end
    end
    
    %set the new size 
    rows = rows -1; 
    cols = cols-1;
    dim = dim; 
    P = P_new;
end

pnt = P; 
