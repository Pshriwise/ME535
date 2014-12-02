

function tri2stl( fileid, v1, v2, v3 )
% Writes a triangle to file in .stl ASCII format 
% Note: Normal of the triangle is calculated based on the ordering of the
% vertices.

% fileid - file handle to write the triangle to 
% v1,v2,v3 - vertices of this triangle

%compute the normal of this triangle 

%setup triangle vectors
a = v2-v1;
b = v3-v2; 

%get the normal vector
normal = cross(a,b); 

%calc areax2
area = norm(normal); 

%if the triangle area is zero (triangle is degenerate) print warning and
%return
if (0 == area)
    % Warn user that this triangle is being skipped and don't write to file
    disp('Warning: Trignale has zero area. Skipping...')
    return
end

%finish calculating the normal vector
normal = normal./area; 

%now write the triangle to the file 
facet = horzcat(normal, v1, v2, v3);
fprintf(fileid,['facet normal %.16E %.16E %.16E\r\n' ...
             'outer loop\r\n' ...
             'vertex %.16E %.16E %.16E\r\n' ...
             'vertex %.16E %.16E %.16E\r\n' ...
             'vertex %.16E %.16E %.16E\r\n' ...
             'endloop\r\n' ...
             'endfacet\r\n'], facet);
         