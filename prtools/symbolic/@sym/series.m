function t = series(f, varargin)
% SERIES(f) is the fifth order Puiseux approximation
%       of f about the point x=0, where x is obtained via symvar(f,1).
%
% SERIES(f,x) is the fifth order Puiseux approximation
%       of f with respect to x about x=0. 
%
% SERIES(f,x,a) is the fifth order Puiseux approximation
%       of f with respect to x about the point a. 
%
% In addition to that, the calls
%
%   SERIES(f,'PARAM1',val1,'PARAM2',val2,...)
%   SERIES(f,x,'PARAM1',val1,'PARAM2',val2,...)
%   SERIES(f,x,a,'PARAM1',val1,'PARAM2',val2,...)
%
% can be used to specify one or more of the following parameter
% name-value pairs:
%
%   'ExpansionPoint' Compute the Puiseux approximation about the point a.
%                    Alternatively, you can specify the expansion point
%                    as the third argument a of series: series(f,x,a).
%
%   'Order'          Compute the Puiseux approximation with order n-1,
%                    where n has to be a positive integer.
%                    The default value n=6 is used.
%
%   'Direction'      One of the following strings:
%                    'left', 'right', 'realAxis', 'complexPlane'.
%                    Compute a Puiseux approximation that is valid in a 
%                    small interval to the left of the expansion point; 
%                    in a small interval to the right of the expansion point;
%                    in a small interval both sides of the expansion point;
%                    or in a small open circle in the complex plane around
%                    the expansion point, respectively. 
%                    Default is 'complexPlane'. 
%
%   See also SYM/PADE, SYM/TAYLOR.

%   Copyright 2015 The MathWorks, Inc.

f = sym(f);
x = symvar(f,1);
if isempty(x)
    x = sym('x');
end    
% possible directions:
directions = {'left', 'right', 'realAxis', 'complexPlane'};
p = inputParser;
p.addOptional('x', x, @sym.isVariable);
p.addOptional('a',sym(0));
p.addParameter('Order', 6, @isPositiveInteger);
p.addParameter('ExpansionPoint', sym([]), @(x) ~isempty(x));
p.addParameter('Direction', 'complexPlane', @(x) any(validatestring(x, directions)));
p.parse(varargin{:});

x = p.Results.x;
a = p.Results.a;
b = p.Results.ExpansionPoint;
if ~isempty(b)
    a = b;
end

% write direction in MuPAD syntax
Direction = validatestring(p.Results.Direction, directions);
switch Direction
    case 'left'
        Direction = sym('Left');
    case 'right'
        Direction = sym('Right');
    case 'realAxis'
        Direction = sym('Real');
    otherwise
        Direction = sym('Undirected');
end

tSym = sym(arrayfun(@(F) scalarSeries(F, x, a, p.Results.Order, Direction), ...
    formula(f), 'UniformOutput', false));
t = privResolveOutput(tSym, f);


% local function scalarSeries
% computes the series expansion of scalar sym f
function s = scalarSeries(f, x, a, order, direction)
eq = feval(symengine, '_equal', x, a);
s = feval(symengine, 'series', f, eq, order, direction, ...
    'NoWarning', 'UseGseries = FALSE');
isPuiseux = feval(symengine, 'testtype', s, 'Series::Puiseux');
if ~isPuiseux
   error(message('symbolic:sym:series:CannotComputeSeriesExpansion'))
end   
s = feval(symengine, 'expr', s);
