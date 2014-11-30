

function tris2stl( fid, tri, coords) 
% Takes a set of coordinates and indices and writes them to a file in stl
% ascii format 

% fid - file handle that the triangles will be written to 
% tri - indices of the triangle vertices in coords 
% coords - a set of points for the triangle (expected to be 3D)

%for each triangle, get the vertices and write them to the file

num_tris = size(tri,1)


if( 3 ~= size(tri,2) )
    error('Triangle indices are of the wrong size')
end

for i = 1:num_tris 

    vertex1 = coords(tris(i,1));
    vertex2 = coords(tris(i,2));
    vertex3 = coords(tris(i,3));
    
    tri2stl(fid, vertex1, vertex2, vertex3);
    
end

