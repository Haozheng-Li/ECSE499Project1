%% 
clear;clc;close all

a = 5;
b = 2;
f = @(x,y) x.^2/a^2 + y.^2/b^2-1;
fimplicit(f, 'LineWidth',2);

set(gcf, 'units', 'normalized', 'position', [0.2 0.2 0.6 0.6]);
grid on
axis equal
axis([-(a+0.5), (a+0.5), -(b+0.5), (b+0.5)]);
pause(2)
hold on

rectangle('Position', [-a, -b, 2*a, 2*b], 'EdgeColor', 'r', 'LineWidth', 2);
A=4*a*b;

N = 20000;
xk=-a+(a+a)*rand(1,N);
yk=-b+(b+b)*rand(1,N);
scatter(xk, yk, 'g.');

r=xk.^2/a^2 + yk.^2/b^2-1;
m=find(r<=1);
n=length(m);
S=(n/N)*A