function X = adjoint(A)
%ADJOINT   Adjoint of the symbolic square matrix A.
%   X = ADJOINT(A) computes a matrix X of the same dimensions
%   as A such that A*X = det(A)*eye(n) = X*A, where n is the number  
%   of rows of A. 
%
%   Example: 
%      syms x y z; 
%      A = sym([x, y, z; 2, 1, 0; 1, 0, 2]);
%      X = adjoint(A)
%      simplify(X * A - det(A)*eye(3))
%      simplify(A * X - det(A)*eye(3))
%     
%   See also SYM/DET, SYM/INV, SYM/RANK, DET, INV, RANK.
 
%   Copyright 2012-2013 MathWorks, Inc. 
 
A = privResolveArgs(A);
Asym = formula(A{1});

if any(~isfinite(privsubsref(Asym,':')))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if isempty(Asym) 
    X = sym([]);
else
    if ~ismatrix(Asym) || size(Asym,1)~=size(Asym,2) 
        error(message('symbolic:sym:adjoint:InputMustBeASquareMatrix'));
    else
        X = privUnaryOp(Asym, 'symobj::adjoint');
    end
end

X = privResolveOutput(X, A{1});
