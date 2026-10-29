function f = myfactorial(n)
% Computes n! exactly as a string using vedicmultiply
% Example: myfactorial(10) returns '3628800'

% Validation checks for n
if ~isnumeric(n) || ~isscalar(n) || n < 0
    error('myfactorial:invalidInput', ...
          'Required: Input must be a non-negative integer.');
end

if floor(n) ~= n
    error('myfactorial:invalidInput', ...
          'Required: Input must be an integer.');
end

% The start of any factorial is 1
f = '1';

% Multiply step by step by using vedicmultiply
for k = 2:n
    f = vedicmultiply(f, num2str(k));
end
end
