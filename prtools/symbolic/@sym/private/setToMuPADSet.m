function mset = setToMuPADSet(set)
%setToMuPADSet Convert a string name for a set to a MuPAD set

%   Copyright 2013-2014 The MathWorks, Inc.
S = validatestring(set, {'integer', 'rational', 'real', 'positive'});
switch S
    case 'integer'
        mset = 'Z_';
    case 'rational'
        mset = 'Q_';
    case 'real'
        mset = 'R_';
    case 'positive'
        mset = 'Dom::Interval(0, infinity)';
end
