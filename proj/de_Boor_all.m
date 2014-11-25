

function [c c1 c2] = de_Boor_all( CPs, k, t, u, index) 

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