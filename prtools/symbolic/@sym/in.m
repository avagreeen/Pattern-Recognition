function result = in(x, set)
%IN Symbolic predicate for elementhood.
%   R = IN(X, SET) returns a symbolic Boolean expression that expresses that
%   X is an element of the set SET.
%   X must be an arithmetical expression, SET must be one of the character strings
%   'integer', 'rational', 'real', 'positive'

%   Copyright 2013-2014 The MathWorks, Inc.


mset = setToMuPADSet(set);
if strcmp(mset, 'Dom::Interval(0, infinity)') 
    % express this as inequality
    result = x > 0;
else    
    result = privUnaryOp(x, 'symobj::map', '_in', mset);
end    
    