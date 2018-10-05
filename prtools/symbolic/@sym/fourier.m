function F = fourier(f,varargin)
%FOURIER Fourier integral transform.
%   F = FOURIER(f) is the Fourier transform of the symbolic expression 
%   or function f with default independent variable x. If f does not 
%   contain x, then the default variable is determined by SYMVAR.  
%   By default, the result F is a function of w. If f = f(w), then F 
%   is returned as a function of the variable v, F = F(v).
%
%   By definition, F(w) = c*int(f(x)*exp(s*i*w*x),x,-inf,inf).
%
%   You can set the parameters c,s to any numeric or symbolic values
%   by setting the preference SYMPREF('FourierParameters',[c,s]). 
%   By default, the values are c = 1 and s = -1.
%
%   F = FOURIER(f,v) returns F as a function of the variable v 
%   instead of the default variable w:
%       F(v) = c*int(f(x)*exp(s*i*v*x),x,-inf,inf).
% 
%   F = FOURIER(f,u,v) treats f as a function of the variable u instead 
%   of the default variable x:
%       F(v) = c*int(f(u)*exp(s*i*v*u),u,-inf,inf).
%
%   Examples:
%    syms t v w x f(x)
%    fourier(1/t)   returns   -pi*sign(w)*1i
%    fourier(exp(-x^2),x,t)   returns   pi^(1/2)*exp(-t^2/4)
%    fourier(exp(-t)*heaviside(t),v)   returns   1/(1+v*1i)
%    fourier(diff(f(x)),x,w)   returns   w*fourier(f(x),x,w)*1i
%
%   See also SYM/IFOURIER, SYM/LAPLACE, SYM/ZTRANS, SUBS, SYMPREF.

%   Copyright 2011 The MathWorks, Inc.

F = transform('fourier', 'x', 'w', 'v', f, varargin{:});
end
