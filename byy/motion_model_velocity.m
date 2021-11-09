function xt = motion_model_velocity(ut, xt_1, dt, gamma_hat)
    x     = xt_1(1);
    y     = xt_1(2);
    theta = xt_1(3);
    v_hat = ut(1);
    w_hat = ut(2);

    sigma = v_hat / w_hat;
    
    x_new = x - sigma*sin(theta) + sigma*sin(theta + w_hat*dt);
    y_new = y + sigma*cos(theta) - sigma*cos(theta + w_hat*dt);
    theta_new = theta + w_hat*dt + gamma_hat*dt;
    
    xt = [x_new, y_new, theta_new]';
end