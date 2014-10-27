function pnts = bezier_bicubic_patch(cps, step)
steps = 1/step;
%out = zeros(3,(steps+1)^2);
out = zeros(3,steps+1,steps+1);
index = 1;
for i = 1:1:steps+1
    for j = 1:1:steps+1
        u = step*i-step;
        v = step*j-step;
        out(:,i,j) = bezier_bicubic_pnt(cps, u, v);
        %out(:,index) = bezier_bicubic_pnt(cps, u, v);
        index = index +1;
    end
end
pnts = out;
