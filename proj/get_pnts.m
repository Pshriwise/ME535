function [pnts] = get_pnts( base, sub_knots, u, num_pnts )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



[a b] = size(base);

if ( a == num_pnts ) 
    pnts = base;
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

pnts = get_pnts(new_base, sub_knots, u, num_pnts);



