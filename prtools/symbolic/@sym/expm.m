function Y = expm(X)
%EXPM   Symbolic matrix exponential.
%   EXPM(A) is the matrix exponential of the symbolic matrix A.
%
%   Examples:
%      syms t
%      A = [0 1; -1 0]
%      expm(t*A)
%
%      A = sym(gallery(5))
%      expm(t*A)

%   Copyright 2014 The MathWorks, Inc.

Xf = formula(X);
if ~ismatrix(Xf) || (size(Xf, 1) ~= size(Xf, 2))
    error(message('symbolic:sym:InputMustBeSquare'));
end

if isempty(Xf)
    Y = X;
    return
end

if any(~isfinite(privsubsref(Xf,':')))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end
Y = privUnaryOp(X, 'symobj::expm');
end
