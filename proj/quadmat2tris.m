function [tri] = quadmat2tris( mat ) 

% mat - a matrix of points for a surface

[ a b c ] = size(mat);

num_tris = 0;
for i = 1:a-1
    for j = 0:b-2 
        
        %create two triangles for each quad in the matrix
        num_tris = num_tris +1; 
        tri(num_tris,:) = [ i+(j)*a (i+1)+(j)*a i+(j+1)*a];
        
        num_tris = num_tris +1;
        tri(num_tris,:) = [ (i+1)+a*(j) (i)+a*(j+1) (i+1)+a*(j+1)];
        
    end
end
