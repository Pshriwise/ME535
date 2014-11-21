%script for plotting circles from 1 to Zero

figure(1);
hold on;

for u = 0.01:0.1:1

    center = [ u u^2 u+u^2 ];
    n = [ u u^2 1+2*u];
    n = n./norm(n);
    pnts = circle(get_circle_rad(u), center, n);
    scatter3(pnts(:,1),pnts(:,2),pnts(:,3))
    plot3(pnts(:,1),pnts(:,2),pnts(:,3), '-')
    
end