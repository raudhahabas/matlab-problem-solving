function s = digit2str(d)
% Convert [0 0 3 2] to '32'; remove leading zeros.

% Remove leading zeros
    k = find(d ~= 0, 1, 'first');
    if isempty(k)
        s = '0';
        return
    end
    d = d(k:end);

% Build string without spaces (inverse of str2digits)
    s = char(d + double('0'));
end
