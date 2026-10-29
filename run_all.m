%% Run every project demo and regenerate all figures
% >> run_all

root = fileparts(mfilename('fullpath'));
projects = {'01-vedic-multiplication', 'demo'
            '02-fox-rabbit-pursuit',   'demo'
            '03-fruit-veg-prices',     'analysis'};

for k = 1:size(projects, 1)
    fprintf('\n===== %s =====\n', projects{k, 1});
    cd(fullfile(root, projects{k, 1}));
    cleanup = onCleanup(@() cd(root));
    run(projects{k, 2});
    close all;
    clear cleanup
end
