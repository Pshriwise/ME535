
function patches = get_patches( points, conn )

patches = zeros(3,4,4,32);

for i = 1:1:32
   for j = 1:4
       for k = 1:4
         patches(:,j,k,i) = points(conn(j,k,i),:);
       end
   end
end
