

function tri2stl( fileid, v1, v2, v3 )

%compute the normal of this triangle 

a = v2-v1;
b = v3-v2; 

normal = cross(a,b); 


area = norm(normal); 

%if the triangle area is zero (triangle is degenerate) print warning and
%return
if (0 == area)
    disp('Warning: Trignale has zero area. Skipping...')
    return
end

%finish calculating the normal vector
normal = normal/area; 

%now write the triangle to the file 

facet = horzcat(normal, v1, v2, v3);
fprintf(fileid,['facet normal %.16E %.16E %.16E\r\n' ...
             'outer loop\r\n' ...
             'vertex %16.E %.16E %.16E\r\n' ...
             'vertex %16.E %.16E %.16E\r\n' ...
             'vertex %16.E %.16E %.16E\r\n' ...
             'endloop\r\n' ...
             'endfacet\r\n'], facet);
         