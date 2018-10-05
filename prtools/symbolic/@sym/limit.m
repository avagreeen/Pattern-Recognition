function r = limit(f,x,a,dir)
%LIMIT    Limit of an expression.
%   LIMIT(F,x,a) takes the limit of the symbolic expression F as x -> a.
%   LIMIT(F,a) uses symvar(F) as the independent variable.
%   LIMIT(F) uses a = 0 as the limit point.
%   LIMIT(F,x,a,'right') or LIMIT(F,x,a,'left') specify the direction
%   of a one-sided limit.
%
%   Examples:
%     syms x a t h;
%
%     limit(sin(x)/x)                 returns   1
%     limit((x-2)/(x^2-4),2)          returns   1/4
%     limit((1+2*t/x)^(3*x),x,inf)    returns   exp(6*t)
%     limit(1/x,x,0,'right')          returns   inf
%     limit(1/x,x,0,'left')           returns   -inf
%     limit((sin(x+h)-sin(x))/h,h,0)  returns   cos(x)
%     v = [(1 + a/x)^x, exp(-x)];
%     limit(v,x,inf,'left')           returns   [exp(a),  0]

%   Copyright 1993-2011 The MathWorks, Inc.

if ~isa(f,'sym'),   f = sym(f); end
if builtin('numel',f) ~= 1,  f = normalizesym(f);  end

% Default x is symvar(f,1).
% Default a is 0.

% dir is empty unless 4 inputs are provided.

switch nargin
case 1, 
   a = '0';
   x = symvar(f,1);
   dir = 'Real';
case 2, 
   a = x;
   x = symvar(f,1);
   dir = 'Real';
case 3
   dir = 'Real';
case 4
   % check that the argument is valid
   dir = validatestring(dir, {'Left', 'Right'}, 'limit', 'direction', 4);   
end

if ~sym.isVariable(sym(x))
   error(message('symbolic:limit:InvalidVariable'))
end
if ~isscalar(a)
   error(message('symbolic:limit:NonScalarPoint'))
end    

args = privResolveArgs(f, x, a);
rSym = mupadmex('symobj::map', args{1}.s, 'symobj::limit', args{2}.s, args{3}.s, dir);
r = privResolveOutput(rSym, args{1});
