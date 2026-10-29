%% Vedic multiplication demo
% Run this script from its own folder: >> demo

%% Polynomial product of digits (no carrying yet)
c = myconv('123', '678')

%% Vedic 2-digit multiplication by hand: 12 x 34
A = [1 2];
B = [3 4];

% Vertical for Units
sum1 = A(2) * B(2);
digit1 = mod(sum1, 10);
carry1 = floor(sum1/10);

% Crosswise + carry (if any)
sum2 = A(1) * B(2) + A(2) * B(1) + carry1;
digit2 = mod(sum2, 10);
carry2 = floor(sum2 / 10);

% Vertical for Tens
sum3 = A(1) * B(1) + carry2;
digit3 = mod(sum3, 10);

result = digit3 * 10^2 + digit2 * 10 + digit1

%% General vedicmultiply
pairs = {'12','34'; '3','0'; '456','23'; '7890','1234'; '9999','9999'};
for k = 1:size(pairs, 1)
    fprintf('%6s x %-6s = %s\n', pairs{k,1}, pairs{k,2}, ...
            vedicmultiply(pairs{k,1}, pairs{k,2}));
end

%% Exact factorials beyond double precision
fprintf('\n10!  = %s\n', myfactorial(10));

f159 = myfactorial(159);
fprintf('159! = %s\n', f159);
fprintf('159! has %d digits\n', length(f159));

% For comparison: a double only holds ~16 significant digits
fprintf('factorial(159) as a double = %.15e\n', factorial(159));
