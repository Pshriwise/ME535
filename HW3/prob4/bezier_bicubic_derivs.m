
function [vectors, pnts] = bezier_bicubic_derivs(cps) 

syms u;
syms v;


%Declare te Bernstein matrix 
M = [ -1  3 -3 1;
       3 -6  3 0;
      -3  3  0 0;
       1  0  0 0; ];

%Setup U and V vectors
U = [ u^3 u^2 u 1];
V = [ v^3 v^2 v 1];
X = U*M*squeeze(cps(1,:,:))*transpose(M)*transpose(V);
Y = U*M*squeeze(cps(2,:,:))*transpose(M)*transpose(V);
Z = U*M*squeeze(cps(3,:,:))*transpose(M)*transpose(V);

pu = [diff(X,u); diff(Y,u); diff(Z,u)];

pv = [diff(X,v); diff(Y,v); diff(Z,v)];
 
pnts = [ bezier_bicubic_pnt(cps, 0, 0.5) bezier_bicubic_pnt(cps, 1, 0.5) bezier_bicubic_pnt(cps, 0.5, 0) bezier_bicubic_pnt(cps, 0.5, 1)] ;
vectors =  [subs(pu, {u,v},{0,0.5}) subs(pu, {u,v},{1,0.5}) subs(pv, {u,v},{0.5,0}) subs(pv, {u,v},{0.5,1})];
vectors = vectors + pnts;

