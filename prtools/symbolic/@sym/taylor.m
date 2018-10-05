function t = taylor(f, varargin)
% TAYLOR(f) is the fifth order Taylor polynomial approximation
%       of f about the point x=0 (also known as fifth order
%       Maclaurin polynomial), where x is obtained via symvar(f,1).
%
% TAYLOR(f,x) is the fifth order Taylor polynomial approximation
%       of f with respect to x about x=0. x can be a vector.
%       In case x is a vector, multivariate expansion about x(1)=0,
%       x(2)=0,... is used.
%
% TAYLOR(f,x,a) is the fifth order Taylor polynomial approximation
%       of f with respect to x about the point a. x and a can be
%       vectors. If x is a vector and a is scalar, then a is
%       expanded into a vector of the same size as x with all
%       components equal to a. If x and a both are vectors, then
%       they must have same length.
%       In case x and a are vectors, multivariate expansion about
%       x(1)=a(1),x(2)=a(2),... is used.
%
% In addition to that, the calls
%
%   TAYLOR(f,'PARAM1',val1,'PARAM2',val2,...)
%   TAYLOR(f,x,'PARAM1',val1,'PARAM2',val2,...)
%   TAYLOR(f,x,a,'PARAM1',val1,'PARAM2',val2,...)
%
% can be used to specify one or more of the following parameter
% name/value pairs:
%
%   Parameter        Value
%
%   'ExpansionPoint' Compute the Taylor polynomial approximation
%                    about the point a. a can be a vector. If x is a
%                    vector, then a has to be of the same length as x.
%                    If a is scalar and x is a vector, a is expanded into
%                    a vector of the same length as x with all components
%                    equal to a. Note that if x is not given as in
%                    taylor(f,'ExpansionPoint',a), then a must be
%                    scalar (since x is determined via symvar(f,1)).
%                    It is always possible to specify the expansion
%                    point as third argument without explicitly using
%                    a parameter value pair.
%
%   'Order'          Compute the Taylor polynomial approximation with
%                    order n-1, where n has to be a positive integer. The
%                    default value n=6 is used.
%
%   'OrderMode'      Compute the Taylor polynomial approximation using
%                    relative or absolute order. 'Absolute' order is the
%                    truncation order of the computed series. 'Relative'
%                    order n means the exponents of x in the computed
%                    series range from some leading order v to the highest
%                    exponent v + n - 1 (i.e., the exponent of x in the
%                    Big-Oh term is v + n). In this case, n essentially
%                    is the "number of x powers" in the computed series
%                    if the series involves all integer powers of x
%
%   Examples:
%      syms x y z;
%
%      taylor(exp(-x))
%      returns  x^4/24 - x^5/120 - x^3/6 + x^2/2 - x + 1
%
%      taylor(sin(x),x,pi/2,'Order',6)
%      returns  (pi/2 - x)^4/24 - (pi/2 - x)^2/2 + 1
%
%      taylor(sin(x)*cos(y)*exp(x),[x y z],[0 0 0],'Order',4)
%      returns  x - (x*y^2)/2 + x^2 + x^3/3
%
%      taylor(exp(-x),x,'OrderMode','Relative','Order',8)
%      returns  - x^7/5040 + x^6/720 - x^5/120 + x^4/24 - x^3/6 + ...
%               x^2/2 - x + 1
%
%      taylor(log(x),x,'ExpansionPoint',1,'Order',4)
%      returns  x - 1 - 1/2*(x - 1)^2 + 1/3*(x - 1)^3
%
%      taylor([exp(x),cos(y)],[x,y],'ExpansionPoint',[1 1],'Order',4)
%      returns  exp(1) + exp(1)*(x - 1) + (exp(1)*(x - 1)^2)/2 + ...
%              (exp(1)*(x - 1)^3)/6'), cos(1) + (sin(1)*(y - 1)^3)/6 - ...
%               sin(1)*(y - 1) - (cos(1)*(y - 1)^2)/2
%
%      taylor(exp(z)/(x - y),[x,y,z],'ExpansionPoint',[Inf,0,0], ...
%             'OrderMode','Absolute','Order',6)
%      returns  y^2/x^3 + z^2/(2*x) + z^3/(6*x) + z^4/(24*x) + y/x^2 + ...
%               z/x + 1/x + (y*z)/x^2 + (y*z^2)/(2*x^2)
%
%   See also SYM/SYMVAR, SYM/SYMSUM, SYM/DIFF, SUBS.

%   Copyright 1993-2014 The MathWorks, Inc.

p = inputParser;
p.addRequired('f');
if ~isa(f,'sym'), f = sym(f); end
x = symvar(f,1);
p.addOptional('x', x, @(x) isvector(x) && isAllVars(x));
p.addOptional('a',sym(0));
p.addParameter('Order', 6, @isPositiveInteger);
p.addParameter('ExpansionPoint', sym([]), @(x) ~isempty(x));
p.addParameter('OrderMode', 'absolute', @(x) any(validatestring(x,{'absolute','relative'})));
p.parse(f, varargin{:});

ordermode = validatestring(p.Results.OrderMode, {'absolute','relative'});
if strcmp(ordermode,'relative')
    options = ['RelativeOrder = ' int2str(double(p.Results.Order))];
else
    options = ['AbsoluteOrder = ' int2str(double(p.Results.Order))];
end

f = p.Results.f;
x = p.Results.x;
a = p.Results.a;
b = p.Results.ExpansionPoint;
if ~isempty(b)
    a = b;
end

if ~isa(f,'sym'), f = sym(f); end
if builtin('numel',f) ~= 1,  f = normalizesym(f);  end
if ~isa(x,'sym'), x = sym(x); end
if builtin('numel',x) ~= 1,  x = normalizesym(x);  end
if ~isa(a,'sym'), a = sym(a); end
if builtin('numel',a) ~= 1,  a = normalizesym(a);  end

if isempty(x) 
    t = f;
    return;
end

tSym = mupadmex('symobj::taylor',f.s,x.s,a.s,options);
t = privResolveOutput(tSym, f);
