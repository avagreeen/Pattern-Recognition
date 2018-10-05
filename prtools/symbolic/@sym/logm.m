function Y = logm(X)
%LOGM   Symbolic matrix logarithm.
%   LOGM(A) is the matrix logarithm of the symbolic matrix A.
%   Unlike LOGM(A) for a double matrix A, this function does not
%   print a warning if A has negative Eigenvalues.
%
%   Examples:
%      syms t
%      A = [0 1; -1 0]
%      logm(t*A)
%
%      A = sym(gallery(5))
%      logm(t*A)

%   Copyright 2014 The MathWorks, Inc.

Y = privResolveOutput(funm(formula(X),@log),X);
