function fig = plot_chase(res, ttl)
% Plot the fox and rabbit paths returned by simulate_chase.

ang = linspace(0, 2*pi, 400);
fig = figure('Color', 'w');
if ~isMATLABReleaseOlderThan("R2025a")
    theme(fig, "light"); % keep a white background under a dark MATLAB theme
end
hold on; grid on; axis equal;
plot(res.R*sin(ang), res.R*cos(ang), 'k', 'LineWidth', 1.5, ...
     'HandleVisibility', 'off'); % circle
plot([res.A(1) res.E(1)], [res.A(2) res.E(2)], 'k', 'LineWidth', 3, ...
     'DisplayName', 'Fence AE');
plot(res.G(1), res.G(2), 'ks', 'MarkerFaceColor', 'k', 'DisplayName', 'Gap G');
plot(res.xf, res.yf, 'r', 'LineWidth', 2, 'DisplayName', 'Fox');
plot(res.xr, res.yr, 'Color', [0 0.6 0], 'LineWidth', 2, 'DisplayName', 'Rabbit');
plot(res.R*sin(res.theta_b), res.R*cos(res.theta_b), 'o', 'MarkerSize', 9, ...
     'MarkerFaceColor', [0.95 0.75 0], 'MarkerEdgeColor', 'k', 'DisplayName', 'Burrow');
text(res.A(1) + 15, res.A(2) + 25, 'A');
text(res.E(1) + 15, res.E(2), 'E');
xlabel('x (m)'); ylabel('y (m)');
title(sprintf('%s: %s at T = %.3f s', ttl, res.outcome, res.T));
legend('Location', 'southwest');
hold off;
end
