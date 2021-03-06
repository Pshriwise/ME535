

function [c c1 c2] = de_Boor_all( CPs, k, t, u, index) 
% Returns the point on the curve, c, the first derivative of the curve, c1,
% and the second derivative of the curve, c2 for a given bspline curve. 
% Note: This will not return the correct values of derivatives if using weighted CPs
% (NURBS)
% CPs - control points of the curve (any dim)
% k - degree of the bspline curve 
% t - knot vector for the curve 
% u - paramter value for the point to be returned
% index - optional argument indicating the knot vector index that u lies
% upon. If this is passed in as -1, the function will determine the index
% on its own.

%get the size of the knot vector
[a b]= size(t);

%make sure the u value given is valid
if ( u < t(k-1) || u > t(b-(k-1)))
   error('U-value is invalid!');
end


%find the interval value using the knot vector and u if not provided
if( -1 == index) 
    
for i = 1:b-1
    if( u >= t(i) & u<= t(i+1) & t(i) ~= t(i+1))
        index = i;
        break;
    end
end

end

assert( index >=0 ); %make sure index is valid
%adjust index using degree
index = index -(k-1);
%get the points needed to define the curve at u
base = CPs(index:index+k,:);
sub_knots = t(:,index:index-1+(2*k));


%run until we have 3 points remaining
[pnts, knots] = get_pnts(base, sub_knots, u , 3);


if (k > 1)
%calculate the second derivative
a = size(base);
b = size(pnts);
diff = (a(1)-b(1))-1; 
knots = sub_knots(diff+1:end-diff);
%need to setup a special knot vector for this

c2 = (pnts(3,:) - pnts(2,:))/(knots(2+k)-knots(2)) - (pnts(2,:) - pnts(1,:))/(knots(1+k)-knots(1));
c2 = k*(k-1)*c2;
knots = knots(2:end-1);
end

%go one step further with the de_Boor alg
[pnts, knots] = get_pnts( pnts, knots, u, 2);

%now calculate the first derivative
c1 = k*(pnts(2,:)-pnts(1,:))/(knots(2)-knots(1));


%do final step of the de_Boor alg
[pnts, knots] = get_pnts( pnts, knots, u, 1); 

c = pnts(1,:); 



    
end