%script for plotting circles from 1 to Zero

figure(1);
hold on;
%arm path
P = [ 1 2 5; 3 6 8; 5 3 9; 10 8 10];
t = [ 0 0 0 1 1 1];
k = 3;
n = 20;

for u = 0.01:0.01:1

    center = deBoor(k,t,P,u,3);
    du = 0.0001;
    n = (1/du)*(deBoor(k,t,P,u+du,3)-deBoor(k,t,P,u,3));
    n = n./norm(n);
    pnts = circle(get_circle_rad(u), center, n);
    scatter3(pnts(:,1),pnts(:,2),pnts(:,3))
    plot3(pnts(:,1),pnts(:,2),pnts(:,3), '-')
    
end