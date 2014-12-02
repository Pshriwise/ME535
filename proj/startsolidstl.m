function startsolidstl(fileid, solidname) 
% Writes the beginning of a solid, solidname, in .stl ASCII format to a
% file

% fileid - handle of the file to write to 
% solidname - name of the solid to write a start-header for 

fprintf( fileid, 'solid %s\r\n', solidname)

