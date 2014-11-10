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
            
            P_new(i,j,1) = u*P(i,j,1)+v*P(i+1,j,1)+w*P(i,j+1,1);
            P_new(i,j,2) = u*P(i,j,2)+v*P(i+1,j,2)+w*P(i,j+1,2);            
            P_new(i,j,3) = u*P(i,j,3)+v*P(i+1,j,3)+w*P(i,j+1,3);
            
        end
    end
    
    %set the new size 
    rows = rows -1; 
    cols = cols-1;
    dim = dim; 
    P = P_new;
end

pnt = P; 
