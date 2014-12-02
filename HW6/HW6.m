

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




