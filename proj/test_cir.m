%script for plotting circles from 1 to Zero

figure(1);
hold on;

for u = 0:0.1:1

    pnts = circle(get_circle_rad(u), [ 0 0 u ]);
    scatter3(pnts(:,1),pnts(:,2),pnts(:,3))
    plot3(pnts(:,1),pnts(:,2),pnts(:,3), '-')
    
end