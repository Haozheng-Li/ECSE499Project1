function q = landmark_model_known_correspondence(xt, zt, m, sigma_r, sigma_phi)
    x = xt(1);
    y = xt(2);
    theta = xt(3);

    r = zt(1);
    phi = zt(2);
    j = zt(3);
    
    mj = m(:,j);
    
    rhat = sqrt((mj(1)-x)^2+(mj(2)-y)^2);
    phihat = atan2(mj(2)-y, mj(1)-x) - theta + 2*pi;    
    q = normpdf(r - rhat, 0 , sigma_r) * normpdf(phi - phihat, 0 , sigma_phi);
end