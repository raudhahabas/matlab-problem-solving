function c = myconv(a, b)
% Polynomial product of the digits of two number strings.
% Example: myconv('123', '678') returns '6 19 40 37 24', i.e. the
% coefficients c_k = sum_{i+j=k} a_i*b_j before any carrying.

% Convert the string to numeric digits
A = str2digits(a);
B = str2digits(b);

C = conv(A, B);

% Convert to string
c = num2str(C);

end
