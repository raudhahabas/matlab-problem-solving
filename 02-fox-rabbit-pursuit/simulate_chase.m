function res = simulate_chase(mu_f, mu_r)
% Simulate a fox chasing a rabbit around a circular field with a fence.
%
%   res = simulate_chase()            % constant speeds
%   res = simulate_chase(mu_f, mu_r)  % speeds decay with distance run:
%                                     % s(d) = s0 * exp(-mu * d)
%
% Constant speeds are just the special case mu_f = mu_r = 0, so one
% model covers both scenarios.
%
% The state vector is y = [x_f; y_f; d_f; theta; d_r]
%   (x_f, y_f) fox position, d_f distance run by the fox,
%   theta      rabbit angle on the circle (measured from the y-axis),
%   d_r        distance run by the rabbit.

if nargin < 2
    mu_f = 0;
    mu_r = 0;
end

%% Parameters & Geometry
R = 800; % radius of the circle (m)
G = [0; 300]; % gap in the fence the fox must pass through
A = [380; 600]; % fence corner1
E = [450; 320]; % fence corner2

cap_tol = 0.1; % capture tolerance (radius)
G_tol = 1e-2; % tolerance for fox arriving at G

sf0 = 16; % initial fox speed (m/s)
sr0 = 13; % initial rabbit speed (m/s)

theta_b = pi/3; % burrow's angle

y0 = [0; 0; 0; 0; 0]; % fox starts at the origin, rabbit at the top

%% Solver Options
opts1 = odeset('RelTol', 1e-9, 'AbsTol', 1e-12, ...
    'Events', @(t, y) reach_G(y, G, G_tol));

opts2 = odeset('RelTol', 1e-9, 'AbsTol', 1e-12, ...
    'Events', @(t, y) capture_or_escape(y, theta_b, cap_tol, R));

%% Phase 1: Fox running to G
[t1, Y1] = ode45(@(t, y) rhs_towards_G(y, G, sf0, sr0, mu_f, mu_r, R, G_tol), ...
    [0 100], y0, opts1);

%% Phase 2: Chasing
y0g = Y1(end, :)';
[t2, Y2, ~, ~, ie] = ode45(@(t, y) rhs_pursuit(y, A, E, sf0, sr0, mu_f, mu_r, R), ...
    [t1(end) t1(end) + 400], y0g, opts2);

%% Results
t = [t1; t2]; % combine time for phase 1 & 2
Y = [Y1; Y2]; % combine state vectors

res.t = t;
res.xf = Y(:, 1);
res.yf = Y(:, 2);
res.xr = R * sin(Y(:, 4));
res.yr = R * cos(Y(:, 4));

res.T = t(end); % final time
res.fox_final = [res.xf(end), res.yf(end)];
res.separation = hypot(res.xf(end) - res.xr(end), res.yf(end) - res.yr(end));
res.fox_distance = Y(end, 3);

% determine outcome based on final event
if isempty(ie)
    res.outcome = 'No event detected';
elseif ie(end) == 1
    res.outcome = 'Captured';
else
    res.outcome = 'Escaped';
end

% geometry, so the result can be plotted on its own
res.R = R; res.G = G; res.A = A; res.E = E; res.theta_b = theta_b;
end

%% Functions Segment
function [sf, sr] = speeds(y, sf0, sr0, mu_f, mu_r)
    % Speeds decay exponentially with the distance each animal has run
    sf = sf0 * exp(-mu_f * y(3)); % current fox speed
    sr = sr0 * exp(-mu_r * y(5)); % current rabbit speed
end

function dy = rhs_towards_G(y, G, sf0, sr0, mu_f, mu_r, R, G_tol)
    % RHS while fox runs from O straight to G
    a = G - y(1:2);
    n = norm(a);
    if n < G_tol
        % Already at G: stop moving in this phase
        dy = zeros(5, 1);
        return
    end
    a = a / n; % unit direction from fox to G
    [sf, sr] = speeds(y, sf0, sr0, mu_f, mu_r);
    dy = [sf * a; sf; sr / R; sr];
end

function dy = rhs_pursuit(y, A, E, sf0, sr0, mu_f, mu_r, R)
    % RHS after fox has passed G and starts chasing
    f = y(1:2);
    r = [R * sin(y(4)); R * cos(y(4))]; % rabbit position on the circle

    % If fence AE blocks the line of sight, run for corner A instead
    if segments_intersect(f, r, A, E)
        target = A;
    else
        target = r;
    end

    a = target - f;
    a = a / norm(a); % direction for fox
    [sf, sr] = speeds(y, sf0, sr0, mu_f, mu_r);
    dy = [sf * a; sf; sr / R; sr];
end

function [v, isterm, dir] = reach_G(y, G, G_tol)
    % Event: fox reaches G
    v = norm(y(1:2) - G) - G_tol;
    isterm = 1; % stop this ODE phase
    dir = -1; % approach event from positive side
end

function [v, isterm, dir] = capture_or_escape(y, theta_b, cap_tol, R)
    % Events:
    % v1 = capture (distance fox-rabbit <= cap_tol)
    % v2 = escape  (rabbit angle reaches theta_b)
    xr = R * sin(y(4));
    yr = R * cos(y(4));

    v1 = hypot(xr - y(1), yr - y(2)) - cap_tol; % capture
    v2 = y(4) - theta_b; % escape
    v = [v1; v2];
    isterm = [1; 1]; % stop when either happens
    dir = [-1; 1]; % capture: decreasing to 0, escape: increasing to 0
end
