function r = int(f, varargin)
%INT    Integrate
%INT    Integrate
%   INT(S) is the indefinite integral of S with respect to its symbolic
%     variable as defined by SYMVAR. S is a SYM (matrix or scalar).
%     If S is a constant, the integral is with respect to 'x'.
%
%   INT(S,v) is the indefinite integral of S with respect to v. v is a
%     scalar SYM.
%
%   INT(S,a,b) is the definite integral of S with respect to its
%     symbolic variable from a to b. a and b are each double or
%     symbolic scalars. The integration interval can also be specified
%     using a row or a column vector with two elements, i.e., valid
%     calls are also INT(S,[a,b]) or INT(S,[a b]) and INT(S,[a;b]).
%
%   INT(S,v,a,b) is the definite integral of S with respect to v
%     from a to b. The integration interval can also be specified
%     using a row or a column vector with two elements, i.e., valid
%     calls are also INT(S,v,[a,b]) or INT(S,v,[a b]) and
%     INT(S,v,[a;b]).
%
%   INT(...,'IgnoreAnalyticConstraints',VAL) controls the level of
%     mathematical rigor to use on the analytical constraints of the
%     solution  (branch cuts, division by zero, etc). The options for
%     VAL are TRUE or FALSE. Specify TRUE to relax the level of
%     mathematical rigor in finding integrals. The default is FALSE.
%
%   INT(...,'IgnoreSpecialCases',VAL) controls how detailed answers
%     are with respect to special parameter values/ The options for
%     VAL are TRUE or FALSE. Specify TRUE to ignore special cases of
%     parameter values. The default is FALSE.
%
%   INT(...,'PrincipalValue',VAL) is used to request a Cauchy principal
%     value of a definite integral. (The option is ignored for indefinite
%     integration.) The possible values for VAL are TRUE and FALSE,
%     the default is FALSE.

%
%   Examples:
%     syms x x1 alpha u t;
%     A = [cos(x*t),sin(x*t);-sin(x*t),cos(x*t)];
%     int(1/(1+x^2))           returns     atan(x)
%     int(sin(alpha*u),alpha)  returns     -cos(alpha*u)/u
%     int(besselj(1,x),x)      returns     -besselj(0,x)
%     int(x1*log(1+x1),0,1)    returns     1/4
%     int(4*x*t,x,2,sin(t))    returns     -2*t*cos(t)^2 - 6*t
%     int([exp(t),exp(alpha*t)])  returns  [ exp(t), exp(alpha*t)/alpha]
%     int(A,t)                 returns      [sin(t*x)/x, -cos(t*x)/x]
%                                           [cos(t*x)/x,  sin(t*x)/x]
%     int(asin(sin(x)),x,0,5)  returns     (2*pi - 5)^2/2
%     int(asin(sin(x)),x,0,5,'IgnoreAnalyticConstraints',true)
%                              returns     25/2
%     int(x^t,x)               returns     piecewise([t == -1, log(x)], [t ~= -1, x^(t + 1)/(t + 1)])
%     int(x^t,x,'IgnoreSpecialCases',true)
%                              returns     x^(t + 1)/(t + 1)
%     int(1/x,-1,1)            returns     NaN
%     int(1/x,-1,1,'PrincipalValue',true)
%                              returns     0

%   Copyright 1993-2014 The MathWorks, Inc.

f = sym(f);
if builtin('numel',f) ~= 1,  f = normalizesym(f);  end

% parse arguments, step 1: Look for options
narg = nargin;
args = varargin;
% default:
options = 'null()';
k = 1;
a = sym([]);
b = sym([]);
while k <= size(args, 2)
  v = args{k};
  if ischar(v) && any(strcmp(v, {'IgnoreAnalyticConstraints', 'IgnoreSpecialCases', 'PrincipalValue'}))
    if k == size(args, 2);
      error(message('symbolic:sym:optRequiresArg', v))
    end
    value = args{k+1};
    if strcmp(v, 'IgnoreAnalyticConstraints')
        value = sym.checkIgnoreAnalyticConstraintsValue(value);
    end    
    if value == true
      value = 'TRUE';
    elseif value == false
      value = 'FALSE';
    else
      error(message('symbolic:sym:badArgForOpt', v))
    end
    options = [options ', ' v '=' value]; %#ok<AGROW>
    args(k:k+1) = [];
    narg = narg - 2;
  elseif ~ischar(v) && isvector(v) && ...
      (numel(v) == 2 || (isa(v,'symfun') && numel(formula(v)) == 2))
      v = sym(v);
      a = privsubsref(v,1);
      b = privsubsref(v,2);
      k = k+1;
  else
    k = k+1;
  end
end

if narg > 4
  error(message('symbolic:sym:maxrhs'))
end

if isempty(a) && narg <= 2
   % Indefinite integral
   indefinite = true;
   if narg < 2
      x = symvar(f,1);
      if isempty(x), x = sym('x'); end
   else
      x = sym(args{1});
   end
   if ~sym.isVariable(x)
       error(message('symbolic:sym:int:InvalidIntegrationVariable', char(x)));
   end
   rSym = mupadmex('symobj::intindef',f.s,x.s,options);
else
   % Definite integral
   indefinite = false;
   if ~isempty(a)
      if narg < 3
          x = symvar(f,1);
      else
          x = args{1};
      end
      if isempty(x), x = sym('x'); end
   elseif narg < 4
      x = symvar(f,1);
      if isempty(x), x = sym('x'); end
      a = args{1};
      b = args{2};
   else
      x = args{1};
      a = args{2};
      b = args{3};
   end
   b = sym(b);
   a = sym(a);
   if ischar(x), x = sym(x); end
   if ~sym.isVariable(x)
       if isnumeric(x)
          x = num2str(x);
       end
       error(message('symbolic:sym:int:InvalidIntegrationVariable', char(x)));
   end
   rSym = mupadmex('symobj::intdef',f.s,x.s,a.s,b.s,options);
end

if indefinite
    r = privResolveOutput(rSym, f);
else
    r = privResolveOutputAndDelete(rSym, f, x);
end
