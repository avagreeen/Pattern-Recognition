function varargout = dsolve(varargin)
%DSOLVE Symbolic solution of ordinary differential equations.
%   DSOLVE(eqn1,eqn2, ...) accepts symbolic equations representing
%   ordinary differential equations and initial conditions. The
%   equations may be strings or symbolic expressions. 
%
%   By default, the independent variable is 't'. The independent variable
%   may be changed from 't' to some other symbolic variable by including
%   that variable as the last input argument.
%
%   Equations specified as symbolic expressions use '==' for equality. The
%   DIFF function constructs derivatives of symbolic functions (see sym/symfun).
%   Initial conditions involving derivatives must use an intermediate
%   variable. For example,
%     syms x(t)
%     Dx = diff(x);
%     dsolve(diff(Dx) == -x, Dx(0) == 1)
%
%   Equations specified as strings may use '==' or '=' for equality.
%   The letter 'D' denotes differentiation with respect to the independent
%   variable, i.e. usually d/dt.  A "D" followed by a digit denotes
%   repeated differentiation; e.g., D2 is d^2/dt^2.  Any characters
%   immediately following these differentiation operators are taken to be
%   the dependent variables; e.g., D3y denotes the third derivative
%   of y(t). Note that the names of symbolic variables should not contain
%   the letter "D".
%   If expressed as strings several equations or initial conditions may 
%   be grouped together, separated by commas, in a single input argument.
%
%   Initial conditions are specified by equations like 'y(a)=b' or
%   'Dy(a) = b' where y is one of the dependent variables and a and b are
%   constants.  If the number of initial conditions given is less than the
%   number of dependent variables, the resulting solutions will obtain
%   arbitrary constants, C1, C2, etc.
%   
%   Three different types of output are possible.  For one equation and one
%   output, the resulting solution is returned, with multiple solutions to
%   a nonlinear equation in a symbolic vector.  For several equations and
%   an equal number of outputs, the results are sorted in lexicographic
%   order and assigned to the outputs.  For several equations and a single
%   output, a structure containing the solutions is returned.
%
%   If no closed-form (explicit) solution is found, an implicit solution is
%   attempted.  When an implicit solution is returned, a warning is given.
%   If neither an explicit nor implicit solution can be computed, then a
%   warning is given and the empty sym is returned.  In some cases involving
%   nonlinear equations, the output will be an equivalent lower order
%   differential equation or an integral.
%
%   DSOLVE(...,'IgnoreAnalyticConstraints',VAL) controls the level of 
%   mathematical rigor to use on the analytical constraints of the solution 
%   (branch cuts, division by zero, etc). The options for VAL are TRUE or 
%   FALSE. Specify FALSE to use the highest level of mathematical rigor
%   in finding any solutions. The default is TRUE.
%
%   DSOLVE(...,'MaxDegree',n) controls the maximum degree of polynomials
%   for which explicit formulas will be used in SOLVE calls during the
%   computation. n must be a positive integer smaller than 5. 
%   The default is 2.
%
%   Examples:
%
%      % Example 1
%      syms x(t) a
%      dsolve(diff(x) == -a*x) returns
%
%        ans = C1/exp(a*t)
%
%      % Example 2: changing the independent variable 
%      x = dsolve(diff(x) == -a*x, x(0) == 1, 's') returns
%
%        x = 1/exp(a*s)
%
%      syms x(s) a
%      x = dsolve(diff(x) == -a*x, x(0) == 1) returns
%
%        x = 1/exp(a*s)
%
%      % Example 3: solving systems of ODEs
%      syms f(t) g(t)
%      S = dsolve(diff(f) == f + g, diff(g) == -f + g,f(0) == 1,g(0) == 2)
%      returns a structure S with fields
%
%        S.f = (i + 1/2)/exp(t*(i - 1)) - exp(t*(i + 1))*(i - 1/2)
%        S.g = exp(t*(i + 1))*(i/2 + 1) - (i/2 - 1)/exp(t*(i - 1))
%
%      syms f(t) g(t)
%      v = [f;g];
%      A = [1 1; -1 1];
%      S = dsolve(diff(v) == A*v, v(0) == [1;2])
%      returns a structure S with fields
%
%        S.f = exp(t)*cos(t) + 2*exp(t)*sin(t)
%        S.g = 2*exp(t)*cos(t) - exp(t)*sin(t)
%
%      % Example 3: using options
%      syms y(t)
%      dsolve(sqrt(diff(y))==y) returns
%      
%        ans = 0
%      
%      syms y(t)
%      dsolve(sqrt(diff(y))==y, 'IgnoreAnalyticConstraints', false) warns
%        Warning: The solutions are subject to the following conditions:
%        (C67 + t)*(1/(C67 + t)^2)^(1/2) = -1 
%      
%      and returns
%       
%        ans = -1/(C67 + t)
%
%      % Example 4: Higher order systems
%      syms y(t) a
%      Dy = diff(y);
%      D2y = diff(y,2);
%      dsolve(D2y == -a^2*y, y(0) == 1, Dy(pi/a) == 0)
%      syms w(t)
%      Dw = diff(w); 
%      D2w = diff(w,2);
%      w = dsolve(diff(D2w) == -w, w(0)==1, Dw(0)==0, D2w(0)==0)
%
%   See also SOLVE, SUBS, SYM/DIFF, odeToVectorfield.

%   Copyright 1993-2014 The MathWorks, Inc.

eng = symengine;

% parse arguments, step 1: Look for options
args = varargin;
% default:
if nargin > 0 && ischar(args{1}) 
    options = '"stringInput", IgnoreAnalyticConstraints = TRUE, IgnoreSpecialCases = TRUE';
else 
    options = 'IgnoreAnalyticConstraints = TRUE, IgnoreSpecialCases = TRUE';
end
k = 1;
while k <= length(args)
  v = args{k};
  if strcmpi(v, 'IgnoreAnalyticConstraints')
    if k == size(args, 2);
      error(message('symbolic:sym:optRequiresArg', v))
    end
    value = sym.checkIgnoreAnalyticConstraintsValue(args{k+1});
    if value == true
      value = 'TRUE';
    else 
      value = 'FALSE';
    end
    options = [options ', IgnoreAnalyticConstraints =' value]; %#ok<AGROW>
    args(k:k+1) = [];
  elseif strcmpi(v, 'IgnoreProperties')
    if k == size(args, 2);
      error(message('symbolic:sym:optRequiresArg', v))
    end
    value = args{k+1};
    if value == true
      value = 'TRUE';
    elseif value == false
      value = 'FALSE';
    else
      error(message('symbolic:sym:badArgForOpt', v))
    end
    options = [options ', IgnoreProperties =' value]; %#ok<AGROW>
    args(k:k+1) = [];
  elseif strcmpi(v, 'MaxDegree')
    if k == size(args, 2)
      error(message('symbolic:sym:optRequiresArg', v))
    end
    value = args{k+1};
    if isnumeric(value) && 0 < value && 5 > value && round(value) == value
      options = [options ', MaxDegree =' int2str(value)]; %#ok<AGROW>
    else
      error(message('symbolic:sym:badArgForOpt', v))
    end
    args(k:k+1) = [];
  elseif strcmpi(v, 'Type')
    if k == size(args, 2)
      error(message('symbolic:sym:optRequiresArg', v))
    end
    value = char(args{k+1});
    options = [options ', Type =' value]; %#ok<AGROW>
    args(k:k+1) = [];
  else
    k = k+1;
  end
end

if isempty(args) || (ischar(args{end}) && isempty(strtrim(args{end})))
   warning(message('symbolic:dsolve:warnmsg3'))
   varargout{1} = sym([]);
   return
end

sol = mupadDsolve(args, options);

% If no solution, give up
failsol = char(eng.feval('_index',sol,'"FailedSolution"'));
nosol = char(eng.feval('_index',sol,'"NoSolution"'));
implicitsol = char(eng.feval('_index',sol,'"ImplicitSolution"'));

if strcmp(nosol,'TRUE') || strcmp(failsol,'TRUE')
   warning(message('symbolic:dsolve:warnmsg2'));
   varargout = cell(1,nargout);
   varargout{1} = sym([]);
   return
end

if strcmp(implicitsol,'TRUE') 
   warning(message('symbolic:dsolve:implicitSolution'));
end

dropped = eng.feval('_index',sol,'"Dropped"');
if ~isempty(dropped)
    dropped = char(eng.feval('output::tableForm',dropped,'String'));
    dropped(dropped=='"') = [];
    dropped = sprintf(['\n' dropped]);
    warning(message('symbolic:solve:ParametrizedFamily',dropped));
end
conds = eng.feval('_index',sol,'"Conditions"');
if ~isempty(conds)
    conds = char(eng.feval('output::tableForm',conds,'String'));
    conds(conds=='"') = [];
    conds = sprintf(['\n' conds]);
    warning(message('symbolic:dsolve:DiscardedConditions',conds));
end

varargout = assignOutputs(nargout,sol);

function out = assignOutputs(nout,sol)
out = cell(1,nout);
eng = symengine;
symvars = eng.feval('_index',sol,'"VariableNames"');
emptysol = char(eng.feval('_index',sol,'"EmptySolution"'));
solTable = eng.feval('_index',sol,'"Sols"');
set = eng.feval('_index',sol,'"SetSolution"');
if (isscalar(symvars) && nout <= 1) || strcmp(emptysol,'TRUE')

   % One variable and at most one output.
   % Return a single scalar or vector sym.
   val1 = eng.feval('symobj::index',solTable,char(symvars));
   val = eng.feval('symobj::extractscalar',val1);
   if isempty(val)
       val = set;
   end
   out{1} = val;

else
   nvars = length(symvars);

   % Form the output structure
   for j = 1:nvars
       name = char(symvars(j));
       fname = name(1:find(name=='(',1)-1);
       val = eng.feval('symobj::index',solTable,name);
       S.(fname) = eng.feval('symobj::extractscalar',val);
   end
   
   if nout <= 1

      % At most one output, return the structure.
      out{1} = S;

   elseif nout == nvars

      % Same number of outputs as variables.
      % Match results in lexicographic order to outputs.
      v = sort(fieldnames(S));
      for j = 1:nvars
         out{j} = S.(v{j});
      end

   else
      error(message('symbolic:dsolve:errmsg5', nvars, nout))
   end
end

    
function T = mupadDsolve(args,options)

narg = length(args);

% The default independent variable is t.
default_varname = true;
x = sym('t');

% Pick up the independent variable, if specified.
if isvarname(char(args{end}))
   default_varname = false;
   x = sym(args{end});
   args(end) = [];
   narg = narg-1;
end
% Concatenate equation(s) and initial condition(s) inputs into SYS.
sys = args(1:narg);
sys_class = cellfun(@class,sys,'UniformOutput',false);
chars = strcmp(sys_class,'char');
sys_char = sys(chars);

% look for problematic symbols names in strings
if ~isempty(sys_char)
    search = regexp(sys_char, ...
        '\<D\d*(psi|euler|beta|gamma|theta|I|PI|E)\>', 'tokens');
    search = [search{:}];
    search = [search{:}];
    if ~isempty(search)
        search = unique(search);
        % Mapping sym on the variables initializes the 
        % corresponding output aliasses on the MuPAD side.
        cellfun(@sym,search,'UniformOutput',false);
        search = strcat(search,'|');
        search = [search{:}];
        search(end) = '';
        sys_char = regexprep(sys_char, ...
            ['\<(D\d*)?(' search ')\>'], '$1$2_Var');
    end
end

% look for symfuns and pick out independent variable
sys_sym = [sys{~chars}];
syminputs = [];
if ~isempty(sys_sym) && isa(sys_sym,'symfun')
    syminputs = argnames(sys_sym);
end
if ~isempty(syminputs)
    if ~isscalar(syminputs)
        error(message('symbolic:dsolve:OneVar'));
    end
    if default_varname
        x = syminputs;
    else
        sys_sym = sys_sym(x);
    end
end
sys_char(2,:) = {','};
sys_str = ['[' sys_char{1:end-1} ']'];
sys = [sys_sym evalin(symengine, sys_str)];
T = feval(symengine,'symobj::dsolve',sys,x,options);
