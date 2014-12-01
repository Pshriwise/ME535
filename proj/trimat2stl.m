
function trimat2stl(fileid, mat)


[ a b c ] size(mat); 

if 3 ~= c
  error('This function is intended for 3D points.');
end


for 2:a-1

      %create a triangle for each new row 
      tri2stl( fileid, squeeze(mat(i,1,:)),squeeze(mat(i-1,1)),squeeze(mat(i-1,2,:)));

  for j = 2:b-(i-1)
    
	    %create two triangles at each noce (one forward and one backward)
            tri2stl(fileid, squeeze(mat(i,j,:)),squeeze(mat(i-1,j,:)),squeeze(mat(i,j-1,:));

	    tri2stl(fileid,squeeze(mat(i,j,:)),squeeze(mat(i-1,j,:)),squeeze(mat(i-1,j+1));

  end
end
