function t = pade(f, varargin)
% PADE approximation of a symbolic expression 
%    PADE(f <, x> <,options>) computes the third order Pade approximant of f at x = 0.
%    If x is not given, it is determined using symvar.
%    PADE(f, x, a <, options>) computes the third order Pade approximant of f at x = a.
%    A different order can be specified using the option 'Order' (see below).
% 
%    The following options can be given as name-value pairs:
%
%    Parameter        Value
%
%    'ExpansionPoint' a 
%                     Compute the Pade approximation about the point a. It is also
%                     possible to specify the expansion point as third argument 
%                     without explicitly using a parameter value pair.
%
%    'Order'          [m, n]
%                     Compute the Pade approximation with numerator order m and
%                     denominator order n.
%
%    'Order'          m
%                     Compute the Pade approximation with both numerator and 
%                     denominator order equal to m. By default, 3 is used.
%
%    'OrderMode'      'Absolute' or 'Relative'.
%                     If the order mode is 'Relative' and f has a zero or pole at the  
%                     expansion point, add the multiplicity of that zero to the order. 
%                     If f has no zero or pole at the expansion point, this option has
%                     no effect. Default is 'Absolute'.
%
%    Examples:
%       syms x
%
%       pade(sin(x))
%       returns (60*x - 7*x^3)/(3*(x^2 + 20))
%
%       pade(cos(x), x, 'Order', [1, 2])
%       returns 2/(x^2 + 2)
%
%    See also TAYLOR.

%    Copyright 2014-2015 The MathWorks, Inc.

f = sym(f);
f = privResolveArgs(f);
f = f{1};

p = inputParser;
x = symvar(f, 1);
if isempty(x)
    % f is constant, we can use any name here
    x = sym('x');
end    
p.addOptional('x', x, @sym.isVariable);
p.addOptional('a', sym(0), @(x) numel(formula(sym(x))) == 1 && ~ischar(x));
p.addParameter('Order', 3, ...
@(x) numel(sym(x)) <= 2 && numel(sym(x)) >= 1 && isIntegerVector(x));
p.addParameter('ExpansionPoint',sym(0), @(x) numel(formula(sym(x))) == 1 && ~ischar(x));
p.addParameter('OrderMode','absolute', @(x) any(validatestring(x,{'absolute','relative'})));
p.parse(varargin{:});

x = p.Results.x;
a = p.Results.a;
b = p.Results.ExpansionPoint;
% if expansion points have been given as a third argument
% and also as an option, the option wins
if b~=sym(0)
    a = b;
end
ordermode = validatestring(p.Results.OrderMode, {'absolute','relative'});
if strcmp(ordermode, 'relative')
    ordermode = sym('Relative');
else
    ordermode = sym('Absolute');
end
    
x = privResolveArgs(sym(x));
x = formula(x{1});
a = privResolveArgs(sym(a));
a = formula(a{1});
order = formula(sym(p.Results.Order));
if numel(order) == 1
    order = [order order];
end        
order = feval(symengine, 'symobj::tolist', order);
order = feval(symengine, '_equal', ordermode, order);

% MuPAD's pade expects variable and expansion point as an equation
% Do not use x == a here as it could turn some inputs into logical
equ = feval(symengine, '_equal', x, a);

tsym = mupadmex('pade', f.s, equ.s, order.s);
if isequal(tsym, evalin(symengine, 'FAIL'))
    % Since the Euclidean Algorithm cannot fail, this means 
    % that no Taylor expansion could be computed
    error(message('symbolic:sym:taylor:CannotComputeTaylorExpansion'))
end
t = privResolveOutput(tsym, f);

% local function isIntegerVector
% checks whether the argument consists of integers
function B = isIntegerVector(s)
if isa(s, 'sym')
    s = feval(symengine, 'symobj::tolist', s);
    B = feval(symengine, 'testtype', s, 'Type::ListOf(Type::NonNegInt)');
else    
    B = all(isnumeric(s) & 0 <= s & round(s) == s);
end    
