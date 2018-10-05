function B = colspace(A)
%COLSPACE Basis for column space.
%   The columns of B = COLSPACE(A) form a basis for the column space of A.
%   SIZE(B,2) is the rank of A.
%
%   Example:
%
%     colspace(sym(magic(4))) is
%
%     [ 1, 0,  0]
%     [ 0, 1,  0]
%     [ 0, 0,  1]
%     [ 1, 3, -3]
%
%   See also SYM/NULL.

%   Copyright 2011 The MathWorks, Inc.

if isempty(A) 
    B = sym([]);
elseif any(~isfinite(privsubsref(A,':')))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf')); 
else 
    B = privUnaryOp(A, 'symobj::colspace');
end
