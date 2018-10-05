function X = pinv(A)
%PINV   Pseudo inverse of a symbolic matrix A.
%   X = PINV(A) computes the pseudo inverse of A. The matrix X is also  
%   called Moore-Penrose inverse of A. 
%
%   For an invertible matrix A, the Moore-Penrose inverse X of A coincides
%   with the inverse of A. In general, only A*X*A = A and X*A*X = X hold.
%   If A has m rows and n columns, then X has n rows and m columns. 
%
%   Example: 
%      A = sym([1,1i,3; 1,3,2]);
%      X = pinv(A);
%      simplify(A*X*A - A)
%      simplify(X*A*X - X)
%
%      syms a b c d; 
%      A = [a,b; c,d];
%      X = pinv(A);
%      simplify(A*X*A - A)
%      simplify(X*A*X - X)
%
%      syms a b c d real;
%      A = [a,b; c,d];
%      X = pinv(A);
%      simplify(A*X*A - A)
%      simplify(X*A*X - X)
%      syms a b c d clear;
%     
%   See also SYM/INV, SYM/RANK, INV, PINV, RANK.
 
%   Copyright 2012 MathWorks, Inc. 

A = privResolveArgs(A);
Asym = formula(A{1});

if any(~isfinite(privsubsref(Asym,':')))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if isempty(Asym) 
    X = sym([]);
else
    X = privUnaryOp(Asym, 'symobj::pinv');
end

X = privResolveOutput(X, A{1});
