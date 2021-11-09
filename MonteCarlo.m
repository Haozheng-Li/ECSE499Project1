%% 
function TotalArea = MonteCarlo(ellipse_a, ellipse_b, circle_a, circle_b, circle_r)
    f_ellipse = @(x,y) x.^2/ellipse_a^2 + y.^2/ellipse_b^2-1;

    fimplicit(f_ellipse, 'LineWidth',2);
    hold on
    rectangle('Position',[circle_a-circle_r,circle_b-circle_r,2*circle_r,2*circle_r],'Curvature',[1,1],'linewidth',1),axis equal

    set(gcf, 'units', 'normalized', 'position', [0.2 0.2 0.6 0.6]);
    grid on
    pause(2)
    hold on

    CircleArea=2*pi*circle_r^2;
    N = 20000;

    theta=0:0.001:360;
    Circle1=circle_a+circle_r*cos(theta);
    Circle2=circle_b+circle_r*sin(theta);
    plot(Circle1,Circle2,'r')

    r=circle_r*sqrt(rand(1,N));
    seta=2*pi*rand(1,N);
    xk=circle_a+r.*cos(seta);
    yk=circle_b+r.*sin(seta);
    hold on
    scatter(xk,yk,'g.');

    r = xk.^2/ellipse_a^2 + yk.^2/ellipse_b^2-1;
    m = find(r<=0);
    n = length(m);
    
    TotalArea=(n/N)*CircleArea;
end


