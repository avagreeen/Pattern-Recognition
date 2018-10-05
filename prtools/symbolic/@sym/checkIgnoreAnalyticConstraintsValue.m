function B = checkIgnoreAnalyticConstraintsValue(v)
% Static auxiliary method of the sym class:
% B = SYM.CHECKIGNOREANALYTICCONSTRAINTSVALUE(v)
% checks the value v of the option IgnoreAnalyticConstraints,
% and throws an error for invalid values.
% It returns true if v is true, and false if v is false.

%   Copyright 2014-2015 The MathWorks, Inc.

symTRUE  = evalin(symengine, 'TRUE');
symFALSE = evalin(symengine, 'FALSE');

if isequal(v, true) || isequal(v, symTRUE)
    B = symTRUE; 
elseif isequal(v, false) || isequal(v, symFALSE) 
    B = symFALSE;
elseif (isa(v, 'sym') || isa(v, 'char')) && any(strcmpi(char(v), {'All', 'None'}))
    error(message('symbolic:sym:DeprecateAllNone'));
else
    error(message('symbolic:sym:badArgForOpt', 'IgnoreAnalyticConstraints'));
end
