
function quadmat2stl( fileid, mat) 

[a b c] = size(mat);

%matrix should hold 3D points 
if 3 ~= c
    error('This function is intended for 3D points.')
end


for i = 1:a-1
    for j = 1:b-1
        
        %write two triangles for each quad
        tri2stl(fileid, squeeze(mat(i,j,:)), squeeze(mat(i+1,j,:)), squeeze(mat(i,j+1,:)));
        
        tri2stl(fileid, squeeze(mat(i,j+1,:)),squeeze(mat(i+1,j,:)),squeeze(mat(i+1,j+1,:)));
    end
end
