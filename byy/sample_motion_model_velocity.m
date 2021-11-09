function xt = sample_motion_model_velocity(xt_1, ut, dt, alpha)
    v           = ut(1);
    w           = ut(2);
    x           = xt_1(1);
    y           = xt_1(2);
    theta       = xt_1(3);

    v_hat       = v + sample_normal_distribution(alpha(1)*v^2 + alpha(2)*w^2);
    w_hat       = w + sample_normal_distribution(alpha(3)*v^2 + alpha(4)*w^2);
    gamma_hat   = sample_normal_distribution(alpha(5)*v^2 + alpha(6)*w^2);

    sigma       = v_hat/w_hat;

    x_new       = x - sigma * sin(theta) + sigma * sin(theta + w_hat * dt);
    y_new       = y + sigma * cos(theta) - sigma * cos(theta + w_hat * dt);
    theta_new   = theta + w_hat*dt + gamma_hat*dt;
    xt = [x_new,y_new,theta_new];
end