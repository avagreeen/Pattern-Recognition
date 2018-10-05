function c = cond(A,varargin)
% cond   Condition number of a symbolic matrix.
%  cond(A) for a symbolic matrix A returns the 2-norm condition
%  number (the ratio of the largest singular value of A to the
%  smallest). Large condition numbers indicate a nearly singular
%  matrix.
%
%   cond(A,P) returns the condition number of A in P-norm:
%
%      NORM(A,P) * NORM(INV(A),P).
%
%   The value for P can be 1, 2, inf, or 'fro':
%
%      cond(A,1) returns the 1-norm condition number.
%
%      cond(A) or cond(A,2) returns the 2-norm condition number.
%
%      cond(A,'fro') returns the Frobenius norm condition number
%
%      cond(A,inf) returns the Infinity norm condition number
%
%   Examples:
%      syms x y z a b c d;
%      A = [x 1/y z^2; x*y 1 y*z^2; y/x-1 sin(x+y) exp(x+y)];
%      B = [x 0 0; 0 y 0; 0 0 z];
%      C = [a b; c d];
%
%      cond(A,1)
%      returns  Inf
%
%      cond(A,2)
%      returns  Inf
%
%      cond(B,'fro')
%      returns  (1/abs(x)^2 + 1/abs(y)^2 + 1/abs(z)^2)^(1/2)* ...
%               (abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2)
%
%      cond(C,inf)
%      returns  max(abs(a) + abs(b), abs(c) + abs(d))* ...
%               max(abs(b)/abs(a*d - b*c) + abs(d)/abs(a*d - b*c), ...
%               abs(a)/abs(a*d - b*c) + abs(c)/abs(a*d - b*c))
%
%      x = cond(sym([1 -2; 3 -4]))
%      returns  (221^(1/2)/4 + 15/4)^(1/2)*(221^(1/2) + 15)^(1/2)
%
%      The result x can further be simplified via
%
%      simplify(x)
%      returns   221^(1/2)/2 + 15/2
%
%   See also cond, inv, norm, rank.

%   Copyright 2012 MathWorks, Inc.

Input = inputParser;
Input.addRequired('A', @(x) isa(A,'sym'));
Input.addOptional('p', 2, @(x) ischar(x) || isnumeric(x) || isa(x,'sym'));

Input.parse(A,varargin{:});
A = Input.Results.A;
p = Input.Results.p;

Ap = privResolveArgs(A);
A = formula(Ap{1});


if length(size(A)) > 2
    error(message('symbolic:sym:cond:FirstArgumentMustBe2D'));
else
    [m, n] = size(A);
end

if any(~isfinite(privsubsref(A,':')))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if ischar(p)
    try 
        p = validatestring(p, {'fro','inf'});
    catch err
        error(message('symbolic:sym:cond:SecondArgumentExpectingFroOrInf'));
    end
else
    if ~isscalar(p) || ~(p==1 || p==2 || p==Inf)
        error(message('symbolic:sym:cond:SecondArgumentExpecting1Or2OrInf'));
    end
end

if m ~= n && ~isequal(p,2)
   % Match Core MATLAB's behavior here!
   error(message('MATLAB:cond:normMismatchSizeA'));
end

if ~isempty(A)
    if p == 1
        c = privBinaryOp(A,sym(1),'symobj::cond');
    elseif p == 2
        c = privBinaryOp(A,sym(2),'symobj::cond');
    elseif ischar(p) && strcmp(p,'fro')
        c = privBinaryOp(A,sym('Frobenius'),'symobj::cond');
    elseif ischar(p) && strcmp(p,'inf') || p == inf
        c = privBinaryOp(A,sym('Infinity'),'symobj::cond');
    end
else
    c = sym(0);
end

c = privResolveOutput(c, Ap{1});

end
