

%Script for visualizing patches for HW 4, Problem 2

clear all; clc; 

intervals = 50;

u_min = 2; u_max = 4; 

v_min = 2, v_max = 3; 


v = linspace(u_min, u_max, intervals); 
u = linspace(v_min, v_max, intervals); 

surf_pnts = zeros(intervals, intervals);

for i = 1:intervals
    for j = 1:intervals 
        surf_pnts(i,j) = 9*u(i)^2 + 5*u(i)*v(j) + 6*v(j)^2 + 4*u(i) + 4*v(j) + 12;
    end
end


surf(u,v,surf_pnts); shading interp;

