

%Script for testing de_Boor_all 
close all; 
clear all;
clc;
%setup a circle arc


CPs = [ 1 0 1; 0.7071 0.7071 0.7071; 0 1 1];

t = [ 0 0 1 1] ;

k = 2; 

u = 0.5 ;

[ c c1 c2 ] = de_Boor_all( CPs, k, t, u, -1); 


c = c./c(end);


pnt = de_Boor(CPs, k, t, u, -1);

pnt = pnt./pnt(end)

if ( c(1,1) ~= pnt(1,1) || c(1,2) ~= pnt(1,2) || c(1,1) ~= c(1,2) )
    error('Curve value returned from de_Boor_all is incorrect')
end
%These are not calculated correctly for NURBS, but they should be in the
%correct direction and have equal values in x and y

if ( c1(1,1) > 0 || c1(1,2) < 0 )
    error('Curve derivative returned from de_Boor_all is incorrect')
end


if ( c2(1,1) > 0 || c2(1,2) > 0)
    error('Curve 2nd derivative returned from de_Boor_all is incorrect')
end

c 
c1
c2




