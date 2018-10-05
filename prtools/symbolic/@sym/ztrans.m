function F = ztrans(f,varargin)
%ZTRANS Z-transform.
%   F = ZTRANS(f) is the Z-transform of the sym f with default
%   independent variable n.  The default return is a function of z:
%   f = f(n) => F = F(z).  The Z-transform of f is defined as:
%      F(z) = symsum(f(n)/z^n, n, 0, inf),
%   where n is f's symbolic variable as determined by SYMVAR.  If
%   f = f(z), then ZTRANS(f) returns a function of w:  F = F(w).
%
%   F = ZTRANS(f,w) makes F a function of the sym w instead of the
%   default z:  ZTRANS(f,w) <=> F(w) = symsum(f(n)/w^n, n, 0, inf).
%
%   F = ZTRANS(f,k,w) takes f to be a function of the sym variable k:
%   ZTRANS(f,k,w) <=> F(w) = symsum(f(k)/w^k, k, 0, inf).
%
%   Examples:
%    syms n k w z f(n)
%    ztrans(2^n)          returns  z/(z-2)
%    ztrans(sin(k*n),w)   returns  (w*sin(k))/(w^2 - 2*cos(k)*w + 1)
%    ztrans(cos(n*k),k,z) returns  (z*(z - cos(n)))/(z^2 - 2*cos(n)*z + 1)
%    ztrans(cos(n*k),n,w) returns  (w*(w - cos(k)))/(w^2 - 2*cos(k)*w + 1)
%    ztrans(f(n+1))       returns  z*ztrans(f(n), n, z) - z*f(0)
%
%   See also SYM/IZTRANS, SYM/LAPLACE, SYM/FOURIER, SUBS.

%   Copyright 2011 The MathWorks, Inc.

F = transform('ztrans', 'n', 'z', 'w', f, varargin{:});
end
