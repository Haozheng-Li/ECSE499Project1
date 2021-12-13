% Inistalize parameters
dt = 1;
x0 = [2, 2, 0]';
alpha = [0.0001, 0.0001, 0.01, 0.0001, 0.0001, 0.0001];
ut = [[1;0], [1;0], [1;0]];
zt = [[2.276;5.249;2], [4.321;5.834;3], [3.418;5.869;3],...
        [3.774;5.911;4], [2.631;5.140;5], [4.770;5.791;6],...
        [3.828;5.742;6], [3.153;5.739;6]];
m = [[0;0], [4;0], [8;0], [8;6], [4;6], [0;6]];
sigma_r = 0.1;
sigma_phi = 0.09;
figure(1);

%% 1. Plot the localization uncertainties at each time step
% subplot(2,2,1);
% N = 1000;    % Suppose sample size is 1000
% total_sample = [];
% 
% for i = 1: N
%     sample = x0;
%     once_sample = [];
%     for j = 1:size(ut,2)
%         sample = sample_motion_model_velocity(sample, ut(1:2, j), dt, alpha);
%         once_sample = [once_sample,sample];
%         
%     end
%     total_sample = [total_sample;once_sample];   
% end
% 
% for i = 1:size(ut, 2) % Scatter plot
%         
%         scatter(total_sample(:,1+3*(i-1)), total_sample(:,2+3*(i-1)),'*');
%         hold on;
% end
% idealmew = [2,3,4,5,6,5,4,3,2;2,2,2,2,3,4,4,4,4];
% plot(idealmew(1,:),idealmew(2,:),'k', 'linewidth',3)
% hold on;
% legend('U1','U2','U3','U4','U5','U6','U7','U8','ideal');
% title('Uncertainty')
% box off;

%% 2.Implement Extended Kalman Filter
% subplot(2,2,2);
xlim([1 7]);
ylim([1 5]);
mu = x0;
sigma = [0, 0, 0; 
         0, 0, 0; 
         0, 0, 0];

total_mu = mu;
total_sigma = sigma;
motion_sample=x0;

% plot_movement(x0, ut, dt); %ideal line
% hold on;
% plot_movement_base_control(x0, ut, dt, alpha); %error line
% hold on;

for i = 1:size(ut, 2)
    x_last = motion_sample(1);
    y_last = motion_sample(2);
    motion_sample = sample_motion_model_velocity(motion_sample, ut(1:2, i), dt, alpha);
    [mu, sigma, mu_t_hat, sigma_t_hat] = EKF_localization_known_correspondences(mu, sigma,  ut(1:2, i)', zt(1:3, i)', m, alpha, sigma_r, sigma_phi,dt);
    total_mu = [total_mu, mu];
    total_sigma = [total_sigma, sigma];
%     error_ellipse(sigma, mu);
    sigma_t_hat
    mu_t_hat
    error_ellipse(sigma_t_hat, mu_t_hat);
end
plot(total_mu(1,:),total_mu(2,:),'r', 'linewidth',2); %EKF Line
hold on;
% legend('black-Ideal','blue-error','red-EKF');
title('Extended Kalman Filter');

box off;

%% 3.Implement Particle filter

% subplot(2,2,3);
% plot_movement(x0, ut, dt);  %ideal line
% plot_movement_base_control(x0, ut, dt, alpha); %error line
% 
% xlim([1 7]);
% ylim([1 5]);
% 
% Xt = x0;
% 
% for i = 1:size(ut, 2)
%     Xt_last_mean = [mean(Xt(1,:)), mean(Xt(2,:))];
%     Xt = Particle_filter(Xt, ut(1:2, i)', zt(1:3, i)', m, alpha, dt, sigma_r, sigma_phi);
%     Xt_mean = [mean(Xt(1,:)), mean(Xt(2,:))];
%     scatter(Xt(1,:), Xt(2,:), 20, ".r");
%     hold on;
%     plot([Xt_last_mean(1), Xt_mean(1)],[Xt_last_mean(2), Xt_mean(2)], 'r'); %particle filter
%     hold on;
%     title('Particle Filter');
%     
% end
% legend('black-ideal','blue-error','red-particle filter');
% 

%% Function : Plot the localization uncertainties
function plot_movement(intial_pos, ut, dt)
    pos = intial_pos;
    for i = 1:size(ut, 2)
        x = pos(1);
        y = pos(2);
        theta = pos(3);
        u = ut(1:2, i); v = u(1); w = u(2);
        if w == 0 && v ~= 0
            x_end = x + cos(theta)*dt;
            y_end = y + sin(theta)*dt;
            theta_end = theta;
        elseif v == pi/2 && w == pi/2
            % when w=pi/2 and dt=1 and v=pi/2, the movement plot is 1/4 circle
            center = [x - sin(theta)*dt, y + cos(theta)*dt];
            % (y-y0)^2 + (x-x0)^2 = r^2

            x_end = x + cos(theta)*dt + sin(theta)*(-dt);

            if theta <= pi && theta >= 2/pi
                y_end = sqrt(1 - (x_end - center(1))^2) + center(2);
            else
                y_end = -sqrt(1 - (x_end - center(1))^2) + center(2);
            end

            theta_end = theta + w * dt;
        end
        pos = [x_end, y_end, theta_end];
        plot([x, x_end],[y, y_end],'k','linewidth',2);
        hold on;
    end
end

%% Function : Plot the movement base on control information
function plot_movement_base_control(intial_pos, ut, dt, alpha)
    motion_sample = intial_pos;
    for i = 1:size(ut, 2)
        x_last = motion_sample(1);
        y_last = motion_sample(2);
        motion_sample = sample_motion_model_velocity(motion_sample, ut(1:2, i), dt, alpha);
        plot([x_last, motion_sample(1)],[y_last, motion_sample(2)], 'b','linewidth',2);
    end
end
