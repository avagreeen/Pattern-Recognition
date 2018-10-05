function s = partfrac(f, varargin)
%PARTFRAC Partial fraction decomposition.
%   PARTFRAC(F, X), where F is a rational function in X, 
%   returns the partial fraction decomposition of F. 
%   The denominator is factored over the rationals.
%   If x is not given then it is determined using SYMVAR. 
%   PARTFRAC(F, X, 'FACTORMODE', MODE)
%   uses the factorization mode MODE to factor the denominator.
%   Possible factorization modes are 'rational'(default), 'real',
%   'complex', and 'full'. See FACTOR for details.
%   In full mode, the result can also be a symbolic sum ranging 
%   over the roots of the denominator.
%
%   Examples:
%      partfrac(1/(x^2 + x), x)
%      returns 1/x - 1/(x+1)
%
%      partfrac(1/(x^2 + x + 1), x, 'FactorMode', 'full')
%      returns 
%      - (3^(1/2)*1i)/(3*(x - (3^(1/2)*1i)/2 + 1/2)) + (3^(1/2)*1i)/(3*(x + (3^(1/2)*1i)/2 + 1/2))
%
%   See also SYM/FACTOR, SYM/SIMPLIFYFRACTION.

%   Copyright 2014-2015 The MathWorks, Inc.

f = sym(f);
x = symvar(f, 1);

p = inputParser;
p.addOptional('x', x, @sym.isVariable);
p.addParameter('FactorMode', 'rational'); 
p.parse(varargin{:});
mode = validatestring(p.Results.FactorMode, {'rational', 'real', 'complex', 'full'});
x = p.Results.x;

if isempty(x)
    % f is constant, and no variable has been given explicitly
    s = f;
    return
end

% translate option to MuPAD syntax
switch mode
    case 'real'
        opt = 'Domain = R_';  
    case 'complex'
        opt = 'Domain = C_';
    case 'full'
        opt = 'Full';
    otherwise
        opt = 'null()';
end

s = privUnaryOp(f, 'symobj::map', 'partfrac', x.s, opt);
