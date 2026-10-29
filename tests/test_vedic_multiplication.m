function tests = test_vedic_multiplication
tests = functiontests(localfunctions);
end

function setupOnce(~)
addpath(fullfile(fileparts(mfilename('fullpath')), '..', '01-vedic-multiplication'));
end

function testDigitConversionRoundTrip(tc)
verifyEqual(tc, str2digits('1234'), [1 2 3 4]);
verifyEqual(tc, digit2str([0 0 3 2]), '32');
verifyEqual(tc, digit2str([0 0 0]), '0');
end

function testInvalidDigitsAreRejected(tc)
verifyError(tc, @() str2digits('12a'), 'str2digits:invalidInput');
verifyError(tc, @() str2digits(''), 'str2digits:invalidInput');
end

function testPolynomialProduct(tc)
verifyEqual(tc, myconv('123', '678'), num2str([6 19 40 37 24]));
end

function testKnownProducts(tc)
verifyEqual(tc, vedicmultiply('12', '34'), '408');
verifyEqual(tc, vedicmultiply('3', '0'), '0');
verifyEqual(tc, vedicmultiply('456', '23'), '10488');
verifyEqual(tc, vedicmultiply('7890', '1234'), '9736260');
verifyEqual(tc, vedicmultiply('9999', '9999'), '99980001');
end

function testMatchesIntegerArithmetic(tc)
% Compare against exact uint64 products for random inputs
rng(0);
for k = 1:200
    a = randi(2^31 - 1);
    b = randi(2^31 - 1);
    expected = sprintf('%d', uint64(a) * uint64(b));
    verifyEqual(tc, vedicmultiply(num2str(a), num2str(b)), expected);
end
end

function testSmallFactorials(tc)
verifyEqual(tc, myfactorial(0), '1');
verifyEqual(tc, myfactorial(5), '120');
verifyEqual(tc, myfactorial(10), '3628800');
end

function testFactorial159(tc)
expected = ['2946702272495038326504339507351214862194953894034126281105653614484641', ...
            '0841713848771686126889882187231222670506551224766381684211831493859308', ...
            '9318679910943515696800488320990633099706213537627257021794896245353619', ...
            '8860613811636208208325279592585625600000000000000000000000000000000000000'];
f = myfactorial(159);
verifyEqual(tc, f, expected);
verifyEqual(tc, length(f), 283);
end

function testFactorialRejectsBadInput(tc)
verifyError(tc, @() myfactorial(-3), 'myfactorial:invalidInput');
verifyError(tc, @() myfactorial(2.5), 'myfactorial:invalidInput');
end
