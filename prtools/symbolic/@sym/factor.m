function f = factor(x, varargin)
%FACTOR Symbolic factorization.
%   FACTOR(S), where S is a SYM, returns all irreducible factors of S.
%   If S is an integer, the prime factorization is computed.
%   To factor an integer N greater than 2^52, use FACTOR(SYM('N')).
%   
%   FACTOR(S, VARS), where VARS is a vector of variables, 
%   returns all irreducible factors of S, but does not split factors
%   that do not contain VARS.
%
%   FACTOR(S, 'FACTORMODE', MODE) or 
%   FACTOR(S, VARS, 'FACTORMODE', MODE)
%   factors S in the factorization mode MODE. 
%   The modes differ only in the case of univariate polynomials.
%   Possible values:
%   'rational' - rational factorization. 
%                Result can contain only those irrational subexpressions 
%                that occur already in the input.
%                This is the default mode.
%   'full'     - factor into symbolic linear factors. 
%   'complex'  - factor numerically into linear factors.
%   'real'     - factor numerically into linear or quadratic real factors. 
%
%   Examples:
%
%      factor(x^9-1) is 
%      [x - 1, x^2 + x + 1, x^6 + x^3 + 1]
%
%      factor(sym('12345678901234567890')) is
%      [2, 3, 3, 5, 101, 3541, 3607, 3803, 27961]
%
%      factor(x^2 * y^2, x) is
%      [y^2, x, x]
%
%      factor(x^2 + 1, 'FactorMode', 'rational') is
%      [x^2 + 1]
%
%      factor(x^2 + 1, 'FactorMode', 'full') is
%      [x - 1i, x + 1i]
%
%   See also FACTOR, SYM/SIMPLIFY, SYM/EXPAND, SYM/COLLECT, SYM/PARTFRAC.

%   Copyright 1993-2014 The MathWorks, Inc.

x = sym(x);
xsym = privResolveArgs(x);
xsym = formula(xsym{1});

if ~isscalar(xsym)
    error(message('symbolic:sym:ExpectingScalar1'));
end    

if ~isfinite(xsym)
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if isa(x, 'symfun')
   defaultvars = argnames(x);
else
   defaultvars = 'default'; 
end    

p = inputParser;
p.addOptional('vars', defaultvars, @checkVariables);
p.addParameter('FactorMode', 'rational'); 
p.parse(varargin{:});
vars = p.Results.vars;
mode = validatestring(p.Results.FactorMode, {'rational', 'real', 'complex', 'full'});

% translate option to MuPAD syntax
switch mode
    case 'real'
        opt = 'R_';  
    case 'complex'
        opt = 'C_';
    case 'full'
        opt = 'Full';
    otherwise
        opt = 'null()';
end


if strcmp(vars, 'default')
    isUnit = @(X) false;
else
    varlist = feval(symengine, 'symobj::tolist', vars);
    isUnit = @(X) ~feval(symengine, 'has', X, varlist);
end    

% compute a Factored object
l = feval(symengine, 'factor', xsym, opt);

% and convert it to a cell array
c = num2cell(children(l));

% unit factor
u = c{1};

% vector of factors
% cannot precompute length, append factors one by one
fsym = sym([]);

% l ist a list [unit, factor1, multiplicity1, ...]
for k=2:2:numel(c)
    fac = c{k};
    multiplicity = c{k+1};
    if isUnit(fac)
        u = u * fac^multiplicity;
    elseif multiplicity == 1
        % important special case, avoid repmat
        fsym = [fsym fac]; %#ok<AGROW>
    elseif multiplicity < 0
        fsym = [fsym repmat(1/fac, 1, -multiplicity)]; %#ok<AGROW>
    else
        fsym = [fsym repmat(fac, 1, multiplicity)]; %#ok<AGROW>
    end    
end

% add the unit factor if it does not equal 1
% but let factor(1) = 1, not empty sym
if u ~= 1 || isempty(fsym)
    fsym = [u fsym];
end    
    
f = privResolveOutput(fsym, x);

% auxiliary function to check that the second argument is a vector of variables
function checkVariables(v)
    if ~isempty(v) && (~isvector(v) || ~isAllVars(v))
        error(message('symbolic:sym:SymVariableVectorExpected'))
    end