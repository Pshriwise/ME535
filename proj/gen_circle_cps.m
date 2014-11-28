
function [CPs] = gen_circle_cps(rad,center, n, sections)
% Function which supplies the control points and weights for a circle
% (weights are supplied in an added dimension)
% rad - radius of the circle
% center - centerpoint of the circle
% n - normal vector to the center of the circle 
% sections - number of sections the circle is broken up into
%perturb normal if needed

%default setion value 
if nargin < 4
    sections = 4;
end 

% corner cases for then normal vector calculation
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

%set center point values (make sure shape of center is correct)
c(1) = center(1);
c(2) = center(2);
c(3) = center(3);

%determine our roataion angle 
angle = 360/(2*sections);

for i = 1:(2*sections+1)

    %start at the center 
    pnts(i,:) = c;
    %set magnitude and weight for this point
    if ( 0 == mod(i,2) ) mag = sqrt(2)*rad; weights(i) = cosd(angle);
    else mag = rad; weights(i) = 1;
    end
    %rotate vector by our angle
    if ( 1 ~= i )perp = cosd(angle)*perp +sind(angle)*cross(perp,n); end
    
    %set the detla vector relative to the center
    v = mag*perp;

    pnts(i,:) = pnts(i,:)+v;

    %renormalize the perp vector
    perp = perp./norm(perp);
                                
end


    
%add weights before returning
for i = 1:(2*sections+1)
    CPs(i,:) = horzcat(pnts(i,:),weights(i));
end

