function b = has(e, s)
%HAS Search for subexpression
%   HAS(E,S) tests whether E contains S. 
%   It returns logical 1 (true) if E contains S, and logical 0 (false) otherwise.
%   If E is an array, HAS(E,S) returns an array of the same size as E 
%   containing logical 1s (true) where the elements of E contain S, 
%   and logical 0s (false) where they do not.
%   If S is an array, HAS(E,S) tests whether E contains any element of S.
%
%   For example, has([x+1, cos(y)+1, y+z], [x, cos(y)]) returns [1 1 0].
%
%   See also SUBS.

%   Copyright 2015 The MathWorks, Inc.

narginchk(2, 2);
if ~isa(e, 'sym') || ~isa(s, 'sym')
   error(message('symbolic:sym:sym:SymInputExpected')) 
end    
e = formula(e);
S = formula(s);
S = reshape(S, 1, numel(S));
% create new variables that we substitute into e
X = sym(zeros(1, numel(S)));
for i=1:numel(S)
    X(i) = feval(symengine, 'genident', '"HAS"');
end
b = ~logical(e == subs(e, S, X));
end