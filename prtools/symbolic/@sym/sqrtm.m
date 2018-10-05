function [X,resnorm] = sqrtm(A)
%SQRTM   Matrix square root.
%   X = SQRTM(A) produces a matrix X such that X*X = A and the
%   eigenvalues of X are the square roots of the eigenvalues of A.
% 
%   [X, resnorm] = sqrtm(A) also returns the residual, 
%   norm(A-X^2,'fro')/norm(A,'fro'). 
% 
%   Example: 
%      A = sym([2, -2, 0; -1, 3, 0; -1/3, 5/3, 2]);
%      X = sqrtm(A);
%      simplify(X*X-A)
%
%      syms a; 
%      A = [4, 1; a, 2];
%      X = sqrtm(A);
%      simplify(X*X-A)
%
%   See also EXPM, SYM/EXPM.

%   Copyright 2012 MathWorks, Inc.

A = privResolveArgs(A);
Asym = formula(A{1});

if size(Asym,1) ~= size(Asym,2)
    error(message('symbolic:sym:sqrtm:MatrixMustBeSquare'));
end

if any(~isfinite(privsubsref(Asym,':')))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if isempty(Asym) 
    X = sym([]);
    if nargout == 2
        resnorm = sym([]);
    end
else
    X = mupadmex('symobj::sqrtm',Asym.s);
    if nargout == 2
        if isscalar(X) && strcmp(char(X),'FAIL')
            resnorm = sym('FAIL');
        else
            resnorm = norm(Asym-X^2,'fro')/norm(Asym,'fro');
        end
    end
end

X = privResolveOutput(X, A{1});
