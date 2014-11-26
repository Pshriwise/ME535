


function pnt = surf_de_Boor( CPs, p, q, tu, tv, u, v)
% Function that returns the point on a Bspline surface
% CPs - matrix of control points for the surface (rows are along u, columns
% along v)
% p - degree of control points along u
% q - degree of control points along v
% tu - knot vector for u
% tv - knot vector for v


[l n m] = size(CPs);
%run the de_Boor function along u 

for i = 1:l
    
    ctrl_pnts = squeeze(CPs(i,:,:));
temp(i,:) = de_Boor(ctrl_pnts,p,tu,u,-1);
end

%calculate the value of the point along v
pnt = de_Boor(temp,q,tv,v,-1);

