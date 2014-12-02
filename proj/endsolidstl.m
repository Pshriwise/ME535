function endsolidstl(fileid, solidname) 
% Prints an ending for a solid in .stl ASCII format 

% fileid - handle of the file to print this to
% solidname - name of the solid write an ending for 

fprintf( fileid, 'endsolid %s\r\n', solidname);