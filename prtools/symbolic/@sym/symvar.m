function v = symvar(S,n)
%SYMVAR Finds the symbolic variables in a symbolic expression or matrix.
%    SYMVAR(S), where S is a scalar or matrix sym, returns a vector sym
%    containing all of the symbolic variables appearing in S. The
%    variables are returned in lexicographical order. If no symbolic variables
%    are found, SYMVAR returns the empty vector.
%    The constants pi, i and j are not considered variables.
%
%    SYMVAR(S,N) returns the N symbolic variables closest to 'x' or 'X'.
%    If N exceeds the number of variables appearing in S, or equals inf,
%    then all variables appearing in S are returned.
%    Upper-case variables are returned ahead of lower-case variables.
%    If S is a symbolic function the inputs to S are listed in front of the
%    other free variables. 
%
%    Examples:
%       symvar(alpha+a+b) returns
%        [a, alpha, b]
%
%       symvar(cos(alpha)*b*x1 + 14*y,2) returns
%        [x1, y]
%
%       symvar(y*(4+3*i) + 6*j) returns
%        y

%   Copyright 2008-2015 The MathWorks, Inc.

Ssym = privResolveArgs(S);
S = Ssym{1};
if nargin == 2
    n = double(n);
    if ~isequal(n, inf)
        validateattributes(n,{'double'},{'scalar','positive','integer'},'','N',2);
    end
    scell = {};
    if isa(S,'symfun')
        sargs= privToCell(argnames(S));
        scell = cellfun(@(x){x.s}, sargs);
    end
    v = mupadmex('symobj::symvar', S.s, num2str(n), scell{:});
else
    v = mupadmex('symobj::symvar', S.s);
end
