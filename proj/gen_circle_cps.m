
function [CPs] = gen_circle_cps(rad,center, n)

%perturb normal if needed
if [ 0 1 0 ] == n 
    n = [ 1e-7 1 0];
end

if [ 0 -1 0] == n
    n = [ 1e-7 -1 0]
end
%get a normal vector (any normal vector for now)
% ax1 = normal(:).'/norm(normal);
% ax23 = null(ax1).';
% axes = [ax1;ax23];
% perp = axes(2,:);

dum = [ -n(3) 0 n(1) ];

perp = cross(dum, n);
perp = perp./norm(perp);

%asssumes the normal vector is of unit length
x = center(1);
y = center(2);
z = center(3);
 
CPs = [x y z; x y z; x y z; x y z; x y z; x y z; x y z; x y z; x y z];

for i = 1:9

    %set magnitude for this point
    if ( 0 == mod(i,2) ) mag = sqrt(2)*rad; 
    else mag = rad; 
    end
    %rotate vector by 45 degrees
    if ( 1 ~= i )perp = cosd(45)*perp +sind(45)*cross(perp,n); end
    
    v = mag*perp;

    CPs(i,:) = CPs(i,:)+v;
    
    perp = perp./norm(perp);
                                
end


    

