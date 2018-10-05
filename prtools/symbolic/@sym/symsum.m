function r = symsum(varargin)
%SYMSUM Symbolic summation.
%   SYMSUM(f) evaluates the sum of a series, where expression f defines the
%   terms of a series, with respect to the default symbolic variable 
%   defaultVar determined by symvar. The value of the default variable 
%   changes from 0 to defaultVar - 1. If f is a constant, the summation is
%   with respect to 'x'.
%
%   SYMSUM(f,x) evaluates the sum of a series, where expression f defines 
%   the terms of a series, with respect to the symbolic variable x. The 
%   value of the variable x changes from 0 to x - 1.
%
%   SYMSUM(f,a,b) evaluates the sum of a series, where expression f defines
%   the terms of a series, with respect to the default symbolic variable 
%   defaultVar determined by symvar. The value of the default variable 
%   changes from a to b. Specifying the range from a to b can also be done
%   using a row or column vector with two elements, i.e., valid calls are
%   also SYMSUM(f,[a,b]) or SYMSUM(f,[a b]) and SYMSUM(f,[a;b]).
% 
%   SYMSUM(f,x,a,b) evaluates the sum of a series, where expression f 
%   defines the terms of a series, with respect to the symbolic variable x.
%   The value of the variable x changes from a to b. Specifying the range
%   from a to b can also be done using a row or column vector with two
%   elements, i.e., valid calls are also SYMSUM(f,x,[a,b]) or 
%   SYMSUM(f,x,[a b]) and SYMSUM(f,x,[a;b]). 
%
%   Examples:
%      symsum(k)                     k^2/2 - k/2
%      symsum(k,0,n-1)               (n*(n - 1))/2
%      symsum(k,0,n)                 (n*(n + 1))/2
%      simplify(symsum(k^2,0,n))     n^3/3 + n^2/2 + n/6
%      symsum(k^2,0,10)              385
%      symsum(k^2,[0,10])            385
%      symsum(k^2,11,10)             0
%      symsum(1/k^2)                 -psi(k, 1)
%      symsum(1/k^2,1,Inf)           pi^2/6
%
%   See also SYM/INT, SYM/SYMPROD.

%   Copyright 1993-2014 The MathWorks, Inc.

narginchk(1,4);
[f, x, a, b] = parseFunctionVariableBounds(varargin{:});
args = privResolveArgs(f);
fsym = args{1};
indefinite = isempty(a);

if ~sym.isVariable(x)
    if isnumeric(x)
        x = num2str(x);
    end
    error(message('symbolic:sym:symsum:InvalidSummationIndex', char(x)));
end

if ~indefinite
    if ~isscalar(a) 
        error(message('symbolic:sym:symsum:InvalidLowerSummationIndex'));
    elseif ~isscalar(b) 
        error(message('symbolic:sym:symsum:InvalidUpperSummationIndex'));
    end
end

if indefinite
   % Indefinite summation
   rSym = mupadmex('symobj::map',fsym.s,'symobj::symsum',x.s);
else
   % Definite summation
   rSym = mupadmex('symobj::map',fsym.s,'symobj::symsum',x.s,a.s,b.s);
end

if indefinite
    r = privResolveOutput(rSym, f);
else
    r = privResolveOutputAndDelete(rSym, f, x);
end    
