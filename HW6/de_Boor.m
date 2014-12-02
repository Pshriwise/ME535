function pnt = de_Boor(CPs, k, t, u, index )
% Returns a point on a bspline curve. 

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
%adjust index
index = index -(k-1);
%get the points needed to define the curve at u
base = CPs(index:index+k,:);
knots = t(:,index:index-1+(2*k));

%base 
%knots

pnt = get_pnts(base, knots, u , 1);
    
end

