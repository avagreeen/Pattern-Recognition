function [eqns,vars] = getEqnsVars(varargin)
%  getEqnsVars(eq1,...,eqn,x1,...,xm)
%  getEqnsVars([eq1,...,eqn],x1,...,xm)
%  getEqnsVars(eq1,...,eqn,[x1,...,xm])
%  getEqnsVars(eq1,...,eqn)
% 
%  Helper function to separate equations from variables. It implements the
%  following strategy: 
%  If the last argument is a vector, then these are the variables.
%  If the first argument is a vector, then these are the equations.
%  Otherwise, scan the input from right to left and treat everything as a 
%  variable which is a single variable. When the first equation is found, 
%  every input parameter to the left of that is also assumed to be an 
%  equation.
%
%  In particular: input p is a variable if logical(symvar(p) == p) gives 
%  true. The first (from right to left) input parameter p for which 
%  logical(symvar(p) == p) gives false, is interpreted as an equation.
%  From that point on every input parameter to the left of p up to the  
%  very first input parameter given is also interpreted as an equation.
%  Additionally: the first input argument is always interpreted as an 
%  equation (calls such as getEqnsVars(x1) do not seem to make much 
%  sense). 
%
%  The vector vars may also be empty, in which case the calling function
%  has to determine the variables itself.

%   Copyright 2012-2014 The MathWorks, Inc.


if ~all(cellfun(@(x) isa(x, 'sym'), varargin))
     error(message('symbolic:sym:sym:SymInputExpected'));
end
     
N = nargin;

switch N 
    case 0
        eqns = sym([]);
        vars = sym([]);
        return;
    case 1
        eqns = formula(varargin{1});
        vars = sym([]);
        return;    
end

if ~isscalar(formula(varargin{N}))
    % The last argument is a vector. We interpret this as the vector of variables.
    % Then the first arguments are equations: either one vector, or several scalars
    vars = varargin{N};
    eqns = cellfun(@formula, varargin(1:N-1), 'UniformOutput', false);  
    eqns = [eqns{:}];    
    checkVariables(vars);
    return;
elseif ~isscalar(formula(varargin{1}))
    % The first argument is a vector. We interpret this as the vector of equations.
    % Then the last arguments are variables: either one vector, or several scalars
    eqns = formula(varargin{1});
    vars = cellfun(@formula, varargin(2:N), 'UniformOutput', false);
    vars = [vars{:}];
    checkVariables(vars);
    return;
end
    
% Input starts with a scalar, and ends with a scalar.
% Seeking backwards for the first non-variable.
for k=N:-1:1
    p = varargin{k};
    if ~sym.isVariable(p) % first equation detected
        break;
    end
end
% Note that if now k==1, this may mean all inputs are variables, or that varargin{1} is not. 
% In both cases, we handle varargin{1} as equation.
eqns = cellfun(@formula, varargin(1:k), 'UniformOutput', false);
eqns = [eqns{:}];
vars = cellfun(@formula, varargin(k+1:N), 'UniformOutput', false);
vars = [vars{:}];
% The variables are actually variables; we only have to check for duplicates
checkDuplicates(vars);
end


function checkVariables(vars)
if isa(vars, 'symfun')
    error(message('symbolic:sym:SymVariableVectorExpected'))
end    
for k=1:numel(vars)
    a = privsubsref(vars, k);
    if ~sym.isVariable(a)
        error(message('symbolic:sym:SymVariableVectorExpected'))
    end            
end
checkDuplicates(vars);
end        

function checkDuplicates(vars)
if numel(unique(vars)) < numel(vars)
    error(message('symbolic:sym:equationsToMatrix:SameVariableMultipleTimes'))
end
end
