function f = iztrans(F,varargin)
%IZTRANS Inverse Z-transform.
%   f = IZTRANS(F) is the inverse Z-transform of the sym F with
%   default independent variable z.  The default return is a function
%   of n:  F = F(z) => f = f(n).  If F = F(n), then IZTRANS returns a
%   function of k: f = f(k).
%
%   f = IZTRANS(F,k) makes f a function of k instead of the default n.
%
%   f = IZTRANS(F,w,k) takes F to be a function of w instead of the
%   default symvar(F) and returns a function of k:  F = F(w) & f = f(k).
%
%   Examples:
%    syms z x k f(n)
%    iztrans(z/(z-2))  returns  2^n
%    iztrans(sin(1/n))  returns  -(1i^(k-1)*((-1)^k-1))/(2*factorial(k))
%    iztrans(exp(x/z),z,k)  returns  x^k/factorial(k)
%    iztrans(ztrans(f(n),n,z),z,k)  returns  f(k)
%
%   See also SYM/ZTRANS, SYM/LAPLACE, SYM/FOURIER, SUBS.

%   Copyright 2011 The MathWorks, Inc.

f = transform('iztrans', 'z', 'n', 'k', F, varargin{:});
end
