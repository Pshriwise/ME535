
function [CPs] = gen_circle_cps(rad,center)

normal = [ 0 0 1 ]

%get a normal vector (any normal vector for now)
perp = [ -normal(3) normal(1) 0 ]
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
    if ( 1 ~= i )perp = cosd(45)*perp +sind(45)*cross(perp,normal); end
    
    v = mag*perp;

    CPs(i,:) = CPs(i,:)+v;
    
    perp = perp./norm(perp);
                                
end


    

