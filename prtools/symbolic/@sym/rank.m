function r = rank(A)
%RANK   Symbolic matrix rank.
%   RANK(A) is the rank of the symbolic matrix A.
%
%   Example:
%       rank([a b;c d]) is 2.

%   Copyright 2013 The MathWorks, Inc.

if any(~isfinite(privsubsref(A,':')))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end
r = double(privUnaryOp(A, 'symobj::rank'));
end
