%% Fox and rabbit pursuit demo
% Run this script from its own folder: >> demo

scenarios = {
    'Constant speeds',    0,      0,      'constant_speed.png'
    'Fatigue (decaying)', 0.0002, 0.0008, 'fatigue.png'
};

for k = 1:size(scenarios, 1)
    [name, mu_f, mu_r, file] = scenarios{k, :};
    res = simulate_chase(mu_f, mu_r);

    fprintf('\n%s (mu_f = %g, mu_r = %g)\n', name, mu_f, mu_r);
    fprintf('  Outcome:              %s\n', res.outcome);
    fprintf('  T:                    %.3f s\n', res.T);
    fprintf('  Fox position at T:    (%.3f, %.3f)\n', res.fox_final);
    fprintf('  Fox-rabbit distance:  %.3f m\n', res.separation);
    fprintf('  Distance run by fox:  %.3f m\n', res.fox_distance);

    fig = plot_chase(res, name);
    exportgraphics(fig, fullfile('figures', file), 'Resolution', 150);
end
