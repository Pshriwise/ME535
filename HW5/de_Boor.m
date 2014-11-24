function pnt = de_Boor(CPs, k, t, u, index )

%get the size of the knot vector
[a b]= size(t);

%make sure the u value given is valid
if ( u < t(k-1) || u > t(b-(k-1)))
   error('U-value is invalid!');
end


%find the interval value using the knot vector and u
if( -1 == index) 
    
%index = -1;
for i = 1:b-1
    if( u >= t(i) & u<= t(i+1) & t(i) ~= t(i+1))
        index = i;
        break;
    end
end

end

assert( index >=0 );
%adjust index
index = index -(k-1);
%get the points needed to define the curve at u
base = CPs(index:index+k,:);
knots = t(:,index:index-1+(2*k));

%base 
%knots

pnt = get_pnts(base, knots, u , 1);
    
end

