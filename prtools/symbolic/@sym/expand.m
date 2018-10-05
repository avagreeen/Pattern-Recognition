function r = expand(varargin)
%EXPAND Symbolic expansion.
%   EXPAND(S) writes each element of a symbolic expression S as a
%   product of its factors.  EXPAND is most often used on polynomials,
%   but also expands trigonometric, exponential and logarithmic functions.
%
%   EXPAND(S,'ArithmeticOnly',true) limits expansion to basic arithmetic,
%   whereas EXPAND(S,'ArithmeticOnly',false) (which is the default) will
%   also expand trigonometric and other special functions.
%   
%   EXPAND(S,'IgnoreAnalyticConstraints',VAL) controls the level of 
%   mathematical rigor to use on the analytical constraints while simplifying 
%   (branch cuts, division by zero, etc). The options for VAL are TRUE or 
%   FALSE. Specify TRUE to relax the level of mathematical rigor
%   in the rewriting process. The default is FALSE.
%
%   Examples:
%      expand((x+1)^3)   returns  x^3+3*x^2+3*x+1
%      expand(sin(x+y))  returns  sin(x)*cos(y)+cos(x)*sin(y)
%      expand(exp(x+y))  returns  exp(x)*exp(y)
%      expand((exp(x+y)+1)^2,'ArithmeticOnly',true)
%                        returns  exp(2*x + 2*y) + 2*exp(x + y) + 1
%      expand(log(x*y))  returns  log(x*y)
%      expand(log(x*y),'IgnoreAnalyticConstraints',true)
%                        returns  log(x)+log(y)
%
%   See also SYM/SIMPLIFY, SYM/FACTOR, SYM/COLLECT.

%   Copyright 1993-2014 The MathWorks, Inc.

p = inputParser;
p.addRequired('s', @(x) isa(x, 'sym'));
p.addParameter('IgnoreAnalyticConstraints', false);
p.addParameter('ArithmeticOnly', false, @(a) isscalar(a) && ~isa(a,'symfun') && (a==true || a==false));
p.addParameter('MaxExponent',  uint32(2)^31 - 1, @(value) isscalar(value) && isnumeric(value) && 0 <= value && round(value) == value);

p.parse(varargin{:});
res = p.Results;

options = 'null()';

if sym.checkIgnoreAnalyticConstraintsValue(res.IgnoreAnalyticConstraints)
    options = [options, ', IgnoreAnalyticConstraints'];
end 
if res.ArithmeticOnly
    options = [options, ', ArithmeticOnly'];
end
options = [options ', MaxExponent =' int2str(res.MaxExponent)];
r = privUnaryOp(res.s, 'symobj::map', 'expand', options);
