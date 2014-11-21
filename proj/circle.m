%Circle function
function [cir_pnts] = circle(rad, center, n)

P = gen_circle_cps(rad, center, n);
P
[a b] = size(P);
P = [P ones(a,1)];
%P = [ 1 0 0 1;  1 1 0 1; 0 1 0 1; -1 1 0 1; -1 0 0 1; -1 -1 0 1; 0 -1 0 1; 1 0 0 1]
w = [ 1 sqrt(2)/2 1 sqrt(2)/2 1 sqrt(2)/2 1 sqrt(2)/2 1];
[a,b] = size(P);
%apply weights
for i = 1:a
    P(i,:) = P(i,:)*w(i);
end

t = [ 0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1];
k = 2;
n = 20; 
 
curve = bsplineCurve(P,k,t,n);
[a,b] = size(curve);

for i = 1:a
    for j = 1:b-1
        curve(i,j) = curve(i,j)/curve(i,b);
    end
end

cir_pnts = curve(:,1:b-1);


