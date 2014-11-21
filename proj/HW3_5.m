%%%%%%%%%%%%%%Main program%%%%%%%%%%%%%%%%%
%MMAE545 HW#3-5
%B-spline surface

clear;
clc;
m = 6;
n = 6;
P = zeros(m+1,n+1,3);
% x- coordinates of control points
P(:,:,1) = [60 60 60 60 60 60 60
    50 50 50 50 50 50 50
    40 40 40 40 40 40 40
    30 30 30 30 30 30 30
    20 20 20 20 20 20 20
    10 10 10 10 10 10 10
    0  0  0  0  0  0  0];
% y-coordinates
P(:,:,2) = [ 0 10 20 30 40 50 60
    0 10 20 30 40 50 60
    0 10 20 30 40 50 60
    0 10 20 30 40 50 60
    0 10 20 30 40 50 60
    0 10 20 30 40 50 60
    0 10 20 30 40 50 60];
% z- coordinates
P(:,:,3) = [ 0 5 15 25 20 15  5
    0 15 30 35 40 25 15
    0 15 35 45 50 30 20
    0 25 45 40 35 25 15
    0 30 40 35 35 15 10
    0 10 20 20 30 15  5
    0  0  5 15 10  5  0];
% P(ij) = P(i,j,:);

x = P(:,:,1);
y = P(:,:,2);
z = P(:,:,3);
% plot control polygon
figure(1);
surf(x,y,z,'Linestyle','-','Marker','.');
axis equal;
view([1,2/3,4])
colormap([1 1 1]);
grid off;
% hold on;

% order in u direction
p = 4;
% irder in v direction
q = 4;
% knots in u direction
tu = [0 0 0 0 1 2 3 4 4 4 4];
% knots in v direction
tv = [0 0 0 0 1 2 3 4 4 4 4];

% number of points evaluated in each direction
num = 50;
u = linspace(0,4,num);
v = linspace(0,4,num);
% knot interval index
r = zeros(1,num);
s = zeros(1,num);

Q = zeros(m+1,1,3);
surfP = zeros(num,num,3);
for iv = 1:num,
    % determine knot interval index in v direction
    for j = 1:n+q,
        if v(iv) >= tv(j) && v(iv) < tv(j+1),
            s(iv) = j;
        end
    end
    s(num) = s(num-1);
    
    % evaluate intermediate points
    for k = 1:m+1,
        Q(k,1,:)= coxdeboor3D(P(:,k,:),tv,q,s(iv),v(iv));
    end
    
    for iu = 1:num,
        % determine knot interval index in u direction
        for j = 1:m+p,
            if u(iu) >= tu(j) && u(iu) < tu(j+1),
                r(iu) = j;
            end
        end
        r(num) = r(num-1);
        
        surfP(iu,iv,:) = coxdeboor3D(Q,tu,p,r(iu),u(iu));
    end
end

X = surfP(:,:,1);
Y = surfP(:,:,2);
Z = surfP(:,:,3);
% plot3(X,Y,Z,2);
figure(2);
surf(X,Y,Z);
%mesh(X,Y,Z);
% shading interp
% legend('Control points','B-spline');
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
% set view angle and color
%view([2,3,6])
%colormap([0.5 0.5 1]);
grid off;
%%%%%%%%%%%%%%Main program%%%%%%%%%%%%%%%%%