function r = rref(A)
%RREF   Reduced row echelon form.
%   RREF(A) is the reduced row echelon form of the symbolic matrix A.
%
%   Example:
%       rref(sym(magic(4))) is not the identity.

%   Copyright 2013 The MathWorks, Inc.

if any(~isfinite(privsubsref(A,':')))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end
r = privUnaryOp(A, 'symobj::rref');
end
