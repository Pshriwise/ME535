function [pnts, knots] = get_pnts( base, sub_knots, u, num_pnts )
% Interpolates the base points using the sub_knot vector and a u-value to
% return a given number of points for use in bspline curve calculations 

% base - control points 
% sub_knots - knot vector associated with the given control points 
% u - parameter value used for interpolation 
% num_pnts - number of points at which the recursion should stop


[a b] = size(base);

if ( a == num_pnts ) 
    pnts = base;
    knots = sub_knots;
    return; 
end

offset = a -1; 

new_base = zeros(offset, b);
for i = 1:offset

    coeff1 = (sub_knots(i+offset)-u)/(sub_knots(i+offset)-sub_knots(i));
    coeff2 = (u- sub_knots(i))/(sub_knots(i+offset)-sub_knots(i));
    
    new_base(i,:) = coeff1*base(i,:) + coeff2*base(i+1,:);
    
end

sub_knots = sub_knots(2:end-1);


[pnts, knots] = get_pnts(new_base, sub_knots, u, num_pnts);


