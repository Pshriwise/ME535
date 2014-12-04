

clear all; 
clc; 

fprintf('---------------------- PROBLEM 1 -----------------------\n');
%Define the Curve 
CPs = [ -2 -2 4; 2 -4 1; 6 -3 0; 10 0 0; 10 4 2];
k = 4; 
t = [ 0 0 0 0 1 1 1 1];

%get all values for this curve 

[c c_prime c_prime2 ] = de_Boor_all(CPs, k, t, 0.5, -1); 

disp('The value of the curve at u = 0.5 is: ')
c

disp('The value of the unit tangent vector at u = 0.5 is:');
tangent = c_prime./norm(c_prime)

disp('The value of the unit normal vector at u = 0.5 is: ');
curvature = norm(c_prime2); 

normal = c_prime2./curvature

disp('The value of the bi-normal vector at u = 0.5 is:');
binormal = cross(c_prime,c_prime2)./norm(cross(c_prime,c_prime2))

disp('The curvature at u = 0.5 is":');
curvature

curve = bspline_curve(CPs, k, t, 0.1);

figure();
hold on;
h1 = plot3(CPs(:,1),CPs(:,2),CPs(:,3),'redsquare');
plot3(CPs(:,1),CPs(:,2),CPs(:,3),'black');
h2 = plot3(curve(:,1),curve(:,2),curve(:,3));


tan_pnts = [c;c+tangent]; 

norm_pnts = [c;c+normal]; 

binorm_pnts = [c;c+binormal]; 

h3 = plot3(tan_pnts(:,1),tan_pnts(:,2),tan_pnts(:,3),'green'); 
h4 = plot3(norm_pnts(:,1),norm_pnts(:,2),norm_pnts(:,3),'red'); 
h5 = plot3(binorm_pnts(:,1),binorm_pnts(:,2),binorm_pnts(:,3),'black'); 

legend([h1 h2 h3 h4 h5],'Control Points','Curve','Tangent Vector','Normal Vector','Bi-normal Vector');

fprintf('-----------------------------------------------------\n\n');

fprintf('--------------------- PROBLEM 2 -------------------------\n');

clear all; 
clc; 

%control points 
CPs = [ 10 0 0; 0 10 0; 0 -10 0; 10 -10 0];

%cubic Bezier matrix 
B = [ 1 0 0 0; -3 3 0 0; 3 -6 3 0; -1 3 -3 1];

syms u; 

t = [ 1 u u^2 u^3 ];

%this gives us our function as x(u), y(u), z(u)
curve = t*B*CPs;

%now get the function for norm(dx/du,dy/du,dz/du) which is ds
disp('The differential arc length is:');
ds = diff(curve,'u');
ds = sqrt(sum(ds.^2))

%redefine ds as a function of u_vec to take integral
u_vec = linspace(0,1,60);
ds = @(u_vec) eval(subs(ds,u,u_vec));

%now we can integrate ds from 0 to 1
disp('The length of this curve is:');
length = integral(ds,0,1)


fprintf('-----------------------------------------------------\n\n');

fprintf('--------------------- PROBLEM 3 -------------------------\n');

clear all;

%setup the control points 
CPs(:,1,:) = [ 0 0 0; 3 0 3; 6 0 3; 9 0 0];
CPs(:,2,:) = [ 0 2 2; 3 2 5; 6 2 5; 9 2 2];
CPs(:,3,:) = [ 0 4 0; 3 4 3; 6 4 3; 9 4 0];


%cubic Bezier matrix 
B3 = [ 1 0 0 0; -3 3 0 0; 3 -6 3 0; -1 3 -3 1];

%quadratic Bezier matrix
B2 = [ 1 0 0; -2 2 0; 1 -2 1];

syms u; syms v;

U = [ 1 u u^2 u^3 ];

V = [ 1 v v^2];

%Form the curve polynomial
curve(:,1) = U*B3*CPs(:,:,1)*(V*B2).';
curve(:,2) = U*B3*CPs(:,:,2)*(V*B2).';
curve(:,3) = U*B3*CPs(:,:,3)*(V*B2).';

%setup u(t) and v(t) 
syms t;
ut = 0.5 + 0.25*cos(t);
vt = 0.5 + 0.25*sin(t);


%get the derivatives of u(t) and v(t) wrt t
dudt = diff(ut,t); 
dvdt = diff(vt,t); 

%differentiate the curve wrt u & v
Pu = diff(curve,u); 
Pv = diff(curve,v); 

%Get the 1st fundamental form coefficients
E = dot(Pu,Pu); 
F = dot(Pu,Pv); 
G = dot(Pv,Pv); 

%now substitute in the paths wrt t for u and v
%E = subs(E,[u,v],[ut,vt]); 
%F = subs(F,[u,v],[ut,vt]); 
%G = subs(G,[u,v],[ut,vt]); 

%setup the length integral 
t_vec = linspace(0,2*pi,60); 
ds = sqrt(E*(dudt^2) + 2*F*(dudt*dvdt) + G*(dvdt^2));
ds = subs(ds,[u,v],[ut,vt]); %substitute our parametric path for u and v
ds = @(t_vec) eval(subs(ds,t,t_vec));

disp('The length of the curve is:');
Length = integral(ds,0,2*pi)

%setup the area integral 

%redefine u(t) and v(t) to be u(r,t) and v(r,t) 

syms r;
utr = 0.5 + r*cos(t); 
vtr = 0.5 + r*cos(t);

dA = sqrt(E*G-F^2)*r; % r is to account for change of variables dudv -> rdrdt
dA = subs(dA,[u,v],[utr,vtr]); %substitute our parametric path for u and v

%define a new vector for r
r_vec = linspace(0,0.25,60);

dA = @(t_vec,r_vec) eval(subs(dA,{t,r},{t_vec,r_vec}));

Area = dblquad(dA, 0, 2*pi, 0, 0.25)


fprintf('-----------------------------------------------------\n\n');

fprintf('--------------------- PROBLEM 4 -------------------------\n');

clear all; 

%define the curve
syms u; syms v; 

%set the control points
P(1,1,:) = [0 0 0];
P(2,1,:) = [2 0 0];
P(1,2,:) = [0 2 0];
P(2,2,:) = [1 2 1];

%define the surface
S = squeeze((1-u)*(1-v)*P(1,1,:)+u*(1-v)*P(2,1,:)+v*(1-u)*P(1,2,:)+u*v*P(2,2,:));

%get the derivatives we need for the fundamental coeffs
Su = diff(S,u); 
Sv = diff(S,v); 

Suu = diff(Su,u); 
Suv = diff(Su,v); 
Svv = diff(Sv,v); 

%first fundamental form coeffs
E = dot(Su,Su); 
F = dot(Su,Sv); 
G = dot(Sv,Sv); 

%second fundamental form coeffs
n = cross(Su,Sv); 
n = n./norm(n); 

L = dot(n,Suu); 
M = dot(n,Suv); 
N = dot(n,Svv); 

%setup matrices to determine principal curvatures (eigen values) 

FI = [ E F; F G]; FII = [ L M; M N];

syms k; 
A = det(FII -k*FI); 

%now substitute in our values of u and v 
A = subs(A,[u,v],[0.5,0.5]);

disp('The principal curvatures are:')
k = eval(solve(A,k,0))

fprintf('-----------------------------------------------------\n\n');

fprintf('--------------------- PROBLEM 5 -------------------------\n');
 
clear all; 

%setup the control points 
CPs(:,1,:) = [ 0 0 0; 3 0 3; 6 0 3; 9 0 0];
CPs(:,2,:) = [ 0 2 2; 3 2 5; 6 2 5; 9 2 2];
CPs(:,3,:) = [ 0 4 0; 3 4 3; 6 4 3; 9 4 0];


%cubic Bezier matrix 
B3 = [ 1 0 0 0; -3 3 0 0; 3 -6 3 0; -1 3 -3 1];

%quadratic Bezier matrix
B2 = [ 1 0 0; -2 2 0; 1 -2 1];

syms u; syms v;

U = [ 1 u u^2 u^3 ];

V = [ 1 v v^2];

%Form the curve polynomial
S(:,1) = U*B3*CPs(:,:,1)*(V*B2).';
S(:,2) = U*B3*CPs(:,:,2)*(V*B2).';
S(:,3) = U*B3*CPs(:,:,3)*(V*B2).';

%define our iso-curve
C = subs(S,u,0.5); 

%get derivative (should give our tangent vector as well; 
Cv = diff(C,v); 
tan_vec = eval(Cv,0.5); 








fprintf('-----------------------------------------------------\n\n');











