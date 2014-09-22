

clear all;
close all;



syms u;
syms aox;
syms aoy;


%Define F' 0-4 functions

FP0 = -30*(u^2) + 60*(u^3) - 30*(u^4);
FP1 = 1 - 18*(u^2) + 32*(u^3) - 15*(u^4);
FP2 = u - (9/2)*(u^2) + 6*(u^3) - (5/2)*(u^4);
FP3 = 30*(u^2) - 60*(u^3) + 30*(u^4);
FP4 = -12*(u^2) + 28*(u^3) - 15*(u^4);


% Define basis matrix 

B = [ FP0, FP1, FP2, FP3, FP4];

%Define control point/vector matrix (a1 = 0,0)

A  = [ 1,1; 1,1; aox, aoy; 4,2; 1, -1 ];

%Define P prime

PP = B*A;

%Now square each entry in P

PP= PP.^2;


%Integrate each entry in PP from 0 to 1

PP(1) = int(PP(1),u, 0,1);
PP(2) = int(PP(2),u, 0,1);

%Differentiate the first entry with respect to aox, the second to aoy

PP(1) = diff(PP(1), aox);
PP(2) = diff(PP(2), aoy);

%Now set these equal to 0 and solve for aox and aoy, respectively

x_ans = solve(PP(1) == 0);
y_ans = solve(PP(2) == 0);

% Print the answer in vector form
a_o = [ x_ans, y_ans ]