function [mu_t, sigma_t, mu_t_hat, sigma_t_hat] = EKF_localization_known_correspondences(mu_t_1, simga_t_1, ut, zt, m, alpha, sigma_r, sigma_phi, dt)
    vt = ut(1);
    wt = ut(2);
    % fix wt
    if wt == 0
        wt = 0.000001;
    end
    phi = vt/wt;
    theta = mu_t_1(3);
    
    Gt = [1 0 -phi*cos(theta)+phi*cos(theta+wt*dt); 
          0 1 -phi*sin(theta)+phi*sin(theta+wt*dt); 
          0 0 1];

    Vt = [(-sin(theta)+sin(theta+wt*dt))/wt, vt*(sin(theta)-sin(theta+wt*dt))/(wt)^2+vt*cos(theta+wt*dt)*dt/wt
           (cos(theta)-cos(theta+wt*dt))/wt, -vt*(cos(theta)-cos(theta+wt*dt))/(wt)^2+vt*sin(theta+wt*dt)*dt/wt
           0, dt];
     
    Mt = [alpha(1)*vt^2 + alpha(2)*wt^2 0; 
          0 alpha(3)*vt^2 + alpha(4)*wt^2];

    mu_t_hat = mu_t_1 + [-phi*sin(theta) + phi*sin(theta+wt*dt); 
                         phi*cos(theta) - phi*cos(theta+wt*dt); 
                         wt*dt];
    
    sigma_t_hat = Gt*simga_t_1*Gt' + Vt*Mt*Vt';
    
    Qt = [sigma_r^2 0; 
          0 sigma_phi^2];
      
    j = zt(3);
    mj = m(1:2, j);
    
    q = (mj(1) - mu_t_hat(1))^2 + (mj(2)-mu_t_hat(2))^2;
    z_t_hat = [sqrt(q); 
               atan2(mj(2)-mu_t_hat(2), mj(1)-mu_t_hat(1)) - mu_t_hat(3) + 2*pi];
    
    Ht = [-(mj(1)-mu_t_hat(1))/sqrt(q), -(mj(2)-mu_t_hat(2))/sqrt(q), 0; 
          (mj(2) - mu_t_hat(2))/q, -(mj(1)-mu_t_hat(1))/q, -1];
    
    St = Ht*sigma_t_hat*Ht' + Qt;
    Kt = sigma_t_hat*Ht'*inv(St);
    mu_t = mu_t_hat + Kt*(zt(1:2)' - z_t_hat);
    sigma_t = (eye(3) - Kt*Ht) * sigma_t_hat;
end