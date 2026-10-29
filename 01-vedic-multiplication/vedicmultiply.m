function c = vedicmultiply(a, b)
% Multiply 2 non-negative string integers using the Vedic
% "vertically and crosswise" method. Works for any number of digits,
% because the result is built digit by digit and never stored as a double.
%
% Example: vedicmultiply('12', '34') returns '408'

% String -> digit
    A = str2digits(a);
    B = str2digits(b);

% Start from right to left
    Areverse = fliplr(A);
    Breverse = fliplr(B);

% Diagonal sums (without carry)
    m = length(Areverse);
    n = length(Breverse);
    C = zeros(1, m+n); % m+n-1 diagonal sums plus room for the last carry
    for i = 1:m
        for j = 1:n
            C(i+j-1) = C(i+j-1) + Areverse(i)*Breverse(j);
        end
    end

% Use base 10 for division
    for k = 1:(m+n-1)
        carry = floor(C(k)/10);
        C(k) = mod(C(k), 10);
        C(k+1) = C(k+1) + carry;
    end

% Make a string
    Cresult = fliplr(C);
    c = digit2str(Cresult);
end
