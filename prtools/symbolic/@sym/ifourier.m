function f = ifourier(F,varargin)
%IFOURIER Inverse Fourier integral transform.
%   f = IFOURIER(F) is the inverse Fourier transform of the symbolic 
%   expression or function F with default independent variable w. If 
%   F does not contain w, then the default variable is determined by 
%   SYMVAR. By default, the result f is a function of x.  If F = F(x), 
%   then f is returned as a function of the variable t, f = f(t).
%
%   By definition, 
%       f(x) = abs(s)/(2*pi*c) * int(F(w)*exp(-s*i*w*x),w,-inf,inf).
%
%   You can set the parameters c,s to any numeric or symbolic values
%   by setting the preference SYMPREF('FourierParameters',[c,s]).
%   By default, the values are c = 1 and s = -1.
%
%   f = IFOURIER(F,u) returns f as a function of the variable u 
%   instead of the default variable x:
%       f(u) = abs(s)/(2*pi*c) * int(F(w)*exp(-s*i*w*u),w,-inf,inf).
%
%   f = IFOURIER(F,v,u) treats F as a function of the variable v 
%   instead of the default variable w:
%       f(u) = abs(s)/(2*pi*c) * int(F(v)*exp(-s*i*v*u),v,-inf,inf). 
%
%   Examples:
%    syms t u v w f(x)
%    ifourier(w*exp(-3*w)*heaviside(w))  returns  1/(2*pi*(-3+x*1i)^2)
%    ifourier(1/(1 + w^2),u)   returns   exp(-abs(u))/2
%    ifourier(v/(1 + w^2),v,u)   returns   -(dirac(1,u)*1i)/(w^2+1)
%    ifourier(fourier(f(x),x,w),w,x)   returns   f(x)
%
%   See also SYM/FOURIER, SYM/ILAPLACE, SYM/IZTRANS, SUBS, SYMPREF.

%   Copyright 2011 The MathWorks, Inc.

f = transform('ifourier', 'w', 'x', 't', F, varargin{:});
end
