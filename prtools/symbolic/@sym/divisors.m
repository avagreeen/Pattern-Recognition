function d = divisors(x, vars)
%DIVISORS Divisors of an expression.
%   DIVISORS(S), where S is a SYM, returns the divisors of S.
%   If S is integer or rational, only the nonnegative divisors are returned;
%   if S is nonconstant, only divisors free of constant factors are returned.
%   DIVISORS(S, VARS) returns the divisors of S, such that all factors not 
%   containing vars are considered constant, and divisors containg them are omitted.
%
%   Examples:
%
%      divisors(sym(6)) is
%      [1, 2, 3, 6]
%
%      divisors(x^2-1) is 
%      [1, x - 1, x + 1, (x - 1) * (x + 1)]
%
%      divisors(x^2*y*z^2, [x y]) is
%      [1, x, x^2, y, x*y, x^2*y]
%
%   See also SYM/FACTOR.

%   Copyright 2013 The MathWorks, Inc.

x = sym(x);
xsym = privResolveArgs(x);
xsym = xsym{1};

if ~isscalar(formula(xsym))
    error(message('symbolic:sym:ExpectingScalar1'));
end    

if ~isfinite(xsym)
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if nargin == 1
    dsym = feval(symengine, 'divisors', xsym);
else
    if ~isAllVars(vars)
        error(message('symbolic:sym:SymVariableVectorExpected'))
    end
    vars = feval(symengine, 'symobj::tolist', vars);
    dsym = feval(symengine, 'divisors', xsym, vars);
end

if feval(symengine, 'nops', dsym) > 1
    dsym = feval(symengine, 'symobj::tomatrix', dsym);
else
    dsym = feval(symengine, 'op', dsym, 1);
end    
d = privResolveOutput(dsym, xsym);
