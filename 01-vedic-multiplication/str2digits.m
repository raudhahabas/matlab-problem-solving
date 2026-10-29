function d = str2digits(s)
% Convert a string to digit vector eg '1234' to [1 2 3 4]

    s = char(s);
    if isempty(s) || any(s < '0' | s > '9')
        error('str2digits:invalidInput', ...
              'Input must be a non-empty string of digits 0-9.');
    end

% Subtracting the character '0' maps '0'..'9' to 0..9
    d = double(s) - double('0');
end
