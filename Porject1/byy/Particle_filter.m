function Xt = Particle_filter(x_t_1, ut, zt, m, alpha, dt, sigma_r, sigma_phi)
    M = 1000;
    total_xt = [];
    total_wt = [];
    for i = 1:M
        xt_i = sample_motion_model_velocity(x_t_1, ut, dt, alpha);
        wt_m = landmark_model_known_correspondence(xt_i, zt, m, sigma_r, sigma_phi);
        total_xt = [total_xt, xt_i'];
        total_wt = [total_wt; wt_m];
    end
    scatter(total_xt(1,:), total_xt(2,:), 20, ".b")
    Xt = [];
    for m = 1:M
        y = randsample(1:length(total_xt), 1, true, total_wt);
        Xt = [Xt total_xt(:,y)];
    end
end
