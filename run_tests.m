%% Run the unit tests
% >> run_tests

root = fileparts(mfilename('fullpath'));
results = runtests(fullfile(root, 'tests'));
disp(table(results));
assertSuccess(results);
