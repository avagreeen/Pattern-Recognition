function h = compose(f,g,varargin)
%COMPOSE Functional composition.
%   COMPOSE(f,g) returns f(g(y)) where f = f(x) and g = g(y). 
%   Here x is the symbolic variable of f as defined by SYMVAR and 
%   y is the symbolic variable of g as defined by SYMVAR.
%   If f and g are symbolic functions the x and y are the respective
%   inputs.
%
%   COMPOSE(f,g,z) returns f(g(z)) where f = f(x), g = g(y), and
%   x and y are the symbolic variables of f and g as defined by 
%   SYMVAR. 
%
%   COMPOSE(f,g,x,z) returns f(g(z)) and makes x the independent 
%   variable for f.  That is, if f = cos(x/t), then COMPOSE(f,g,x,z)
%   returns cos(g(z)/t) whereas COMPOSE(f,g,t,z) returns cos(x/g(z)).
%  
%   COMPOSE(f,g,x,y,z) returns f(g(z)) and makes x the independent
%   variable for f and y the independent variable for g.  For
%   f = cos(x/t) and g = sin(y/u), COMPOSE(f,g,x,y,z) returns
%   cos(sin(z/u)/t) whereas COMPOSE(f,g,x,u,z) returns cos(sin(y/z)/t).
% 
%   Examples:
%    syms x y z t u;
%    f(x) = 1/(1 + x^2); g(y) = sin(y); h = x^t; p = exp(-y/u);
%    compose(f,g)         returns   1/(sin(y)^2 + 1)
%    compose(f,g,t)       returns   1/(sin(t)^2 + 1)
%    compose(h,g,x,z)     returns   sin(z)^t
%    compose(h,g,t,z)     returns   x^sin(z)
%    compose(h,p,x,y,z)   returns   (1/exp(z/u))^t
%    compose(h,p,t,u,z)   returns   x^(1/exp(y/z))
%
%   See also SYM/FINVERSE, SYM/SYMVAR, SYM/SUBS, SYMFUN.

%   Copyright 1993-2011 The MathWorks, Inc.

narginchk(2,5);

% Set up the functions f and g as symbolic objects and find
% their symbolic variables varf and varg, respectively.
if ~isa(f,'sym')
    f = sym(f); 
end
if builtin('numel',f) ~= 1,  f = normalizesym(f);  end
varf = symvar(f,1);
if ~isa(g,'sym')
    g = sym(g); 
end
if builtin('numel',g) ~= 1,  g = normalizesym(g);  end
varg = symvar(g,1);
% If either f or g is identically constant, then assign f
% the variable x and g the variable y.
if isempty(varf)
      varf = sym('x');
end
if isempty(varg)
      varg = sym('y');
end

isSymfun = false;
% First consider the case where f = f(x), g = g(y) and we
% wish to compute h = f(g(y)).
if nargin == 2
    if isa(f,'symfun') && isa(g,'symfun')
        varf = argnames(f);
        varg = argnames(g);
        if isscalar(varf) && isscalar(varg)
            isSymfun = true;
        end
    end
    varh = varg;

elseif nargin == 3
% This is the case where f = f(x), g = g(y), and h = f(g(t)).
    varh = sym(varargin{1});  % This is the variable "t".

elseif nargin == 4
% Here, f = f(varargin{1}, v), g = g(y) and h = f(g(z), v).
    varf = sym(varargin{1});
    varh = sym(varargin{2}); % The variable "z".
    if any(symvar(g) == varh);
       varg = varh;
    end

elseif nargin == 5
% In this case, f = f(varargin{3}, v), g = g(varargin{4}, w), and
% h = f(g(z,w), v).
    varf = sym(varargin{1}); % The independent variable for f
    varg = sym(varargin{2}); % The independent variable for g
    varh = sym(varargin{3}); % The variable "z".
end

h = mupadmex('symobj::compose',f.s,g.s,varf.s,varg.s,varh.s);
if isSymfun
    h = symfun(h, varg);
end
