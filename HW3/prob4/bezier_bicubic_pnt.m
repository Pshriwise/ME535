
function pnt = bezier_bicubic_pnt(cps, u, v)

%Declare te Bernstein matrix 
M = [ -1  3 -3 1;
       3 -6  3 0;
      -3  3  0 0;
       1  0  0 0; ];

%Setup U and V vectors
U = [ u^3 u^2 u 1];
V = [ v^3 v^2 v 1];

%Return the point
X = U*M*squeeze(cps(1,:,:))*transpose(M)*transpose(V);
Y = U*M*squeeze(cps(2,:,:))*transpose(M)*transpose(V);
Z = U*M*squeeze(cps(3,:,:))*transpose(M)*transpose(V);

pnt = [ X; Y; Z; ];





