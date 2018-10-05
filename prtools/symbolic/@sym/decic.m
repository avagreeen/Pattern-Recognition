
function [y0, yp0] = decic(eqs,vars,constraints,t0,y0,fixedVars,yp0,options)
%DECIC   Compute consistent initial conditions for a system of first-order
%   implicit ordinary differential equations with algebraic constraints.
%
%   [y0,yp0] = decic(eqs,vars,constr,t0,y0_est,fixedVars,yp0_est,options)
%
%   The call [eqs,constr] = reduceDAEToODE(DA_eqs,vars) reduces the system
%   of differential algebraic equations DA_eqs to the system of implicit
%   ordinary differential equations eqs. It also returns constraint equations
%   constr encountered during the system reduction. For the variables and
%   first derivatives of this ODE system, DECIC finds consistent initial
%   conditions y0, yp0 at the time t0.
%
%   Substituting the numerical values y0, yp0 into the differential equations
%
%   subs(eqs, [t;vars;diff(vars)], [t0; y0; yp0])
%
%   and the constraint equations
%
%   subs(constr, [t;vars;diff(vars)], [t0; y0; yp0])
%
%   produces zero vectors. (Here, vars must be a column vector.)
%
%   The input eqs must consist of first-order differential equations that
%   can be solved for the derivatives of all variables specified in vars.
%   For semi-linear systems, this requires det(M)~=0, where
%   [M,~] = MASSMATRIXFORM(eqs, vars) is the mass matrix of the system.
%
%   The input parameter t0 must be a numerical scalar.
%
%   The input vector y0_est provides numerical estimates for the values
%   of the variables at the time t0.
%
%   The input vector fixedVars has entries 0 or 1. It indicates which
%   elements of y0_est are fixed values not modified during the numerical
%   search. Fixed values of y0_est correspond to values 1 in fixedVars.
%   The 0 entries in fixedVars correspond to those variables in y0_est
%   for which decic solves the constraint equations.
%
%   The number of zero entries must coincide with the number of
%   constraints. The Jacobian matrix of the constraints with respect
%   to the variables vars(fixedVars == 0) must be invertible.
%
%   The optional input vector yp0_est provides numerical estimates
%   for the values of the first-order derivatives of the variables.
%
%   The parameter options is an ODESET object that allows to set
%   tolerances for the numerical search.
%
%   The lengths of the input parameters eqs,vars,y0,fixedVars, and
%   yp0 must be the same.
%
%   Example:
%     Create the following algebraic differential system
%
%     >> syms x(t) y(t);
%        eqs0 = [diff(x(t),t) == cos(t) + y(t), ...
%                x(t)^2 + y(t)^2 == 1];
%        vars = [x(t), y(t)];
%
%     Use REDUCEDAETOODE to convert this system to a system of
%     implicit ODEs.
%
%     >> [eqs, constr, ~] = reduceDAEToODE(eqs0, vars)
%
%     eqs =
%                          diff(x(t), t) - y(t) - cos(t)
%          - 2*x(t)*diff(x(t), t) - 2*y(t)*diff(y(t), t)
%
%     constr =
%                  1 - y(t)^2 - x(t)^2
%
%     Create an option structure that specifies numerical tolerances
%     for the numerical search:
%
%     >> options = odeset('RelTol', 10.0^(-7), 'AbsTol', 10.0^(-7));
%
%     Fix values t0 = 0 for the time and numerical estimates for
%     consistent values of the variables and their derivatives:
%
%     >> t0 = 0;
%        y0_est = [0.1, 0.9];
%        yp0_est = [0.0, 0.0];
%
%     You can treat the constraint as an algebraic equation for the
%     variable x with the fixed parameter y. For this, set
%     fixedVars = [1 0]. Alternatively, you can treat it as an
%     algebraic equation for the variable y with the fixed parameter x.
%     For this, set fixedVars = [0 1]:
%
%     First, set the initial value x(t0) = y0_est(1) = 0.1:
%
%     >> fixedVars = [1 0];
%        [y0,yp0] = decic(eqs,vars,constr,t0,y0_est,fixedVars,yp0_est,options)
%
%     y0 =
%           0.1000
%           0.9950
%
%     yp0 =
%           1.9950
%          -0.2005
%
%     Now, change the initial value y(t0) = y0_est(2) = 0.9 to get
%     different consistent initial values:
%
%     >> fixedVars = [0 1];
%        [y0,yp0] = decic(eqs,vars,constr,t0,y0_est,fixedVars,yp0_est,options)
%
%     y0 =
%          -0.4359
%           0.9000
%
%     yp0 =
%           1.9000
%           0.9202
%
%   See also: REDUCEDAETOODE, ODESET, ODE15I, ODE15S.

%   Copyright 2014 The MathWorks, Inc.

narginchk(6, 8);

yp0pos = 7;
if nargin == 6
   yp0 = [];
   options = struct([]);
elseif nargin == 7
   if isa(yp0, 'struct')
      options = yp0;
      yp0pos = 8;
      yp0 = [];
   else
      options = struct([]);
   end
elseif nargin == 8 && isa(yp0, 'struct')
   tmp = yp0;
   yp0 = options;
   options = tmp;
   yp0pos = 8;
end

[eqs, vars] = checkDAEInput(eqs, vars);

args = privResolveArgs(eqs,vars,constraints,t0,y0,fixedVars,yp0);

if isa(args{1}, 'symfun') % all args{i} are symfuns
  args = cellfun(@formula, args, 'UniformOutput', false);
end
args = cellfun(@(x) reshape(x, numel(x), 1), args, 'UniformOutput', false);
args = cellfun(@checkForNaNsAndInfs, args, 'UniformOutput', false);

% extract the symbolic name of the time variable
t = symvar(args{2});
if numel(t) ~= 1
   error(message('symbolic:sym:decic:AllowOnlyFuncVars'));
end

m = numel(args{1});
n = numel(args{2});
r = numel(args{3});
if m ~= n
   error(message('symbolic:sym:decic:ExpectingAsManyEquationsAsVariables'));
end

t0 = double(args{4});
y0 = double(args{5});
if isempty(args{7})
   yp0 = zeros(n, 1);
else
   yp0 = double(args{7});
end
fixedVars = args{6};
if isempty(fixedVars)
   autoMode = true;
   charIndices = feval(symengine, 'daetools::isSolvable', ...
                       args{3}, args{2}, args{4}, '"ReturnCharIndices"');
   fixedVars = ones(n,1);
   fixedVars(charIndices) = 0;
else
   autoMode = false;
   fixedVars = double(fixedVars);
end

if ~isscalar(t0)
   error(message('symbolic:sym:decic:ExpectingScalar4')); 
end
if numel(y0) ~= n
   error(message('symbolic:sym:decic:InconsistentArguments25'));
end
if numel(fixedVars) ~= n
   error(message('symbolic:sym:decic:InconsistentArguments26'));
end
if numel(yp0) ~= n
   if yp0pos == 7
      error(message('symbolic:sym:decic:InconsistentArguments27'));
   else
      error(message('symbolic:sym:decic:InconsistentArguments28'));
   end
end

boundSymVars = privsubsref(args{2}, fixedVars == 0);
boundSymVals = privsubsref(args{5}, fixedVars == 0);
fixedSymVars = privsubsref(args{2}, fixedVars ~= 0);
fixedSymVals = privsubsref(args{5}, fixedVars ~= 0);

if numel(fixedSymVars) ~= n-r
   error(message('symbolic:sym:decic:InconsistentFixedVars'));
end

% insert the values for the 'fixed' variables. Then solve
% the constraints for the remaining ('bound') variables:
if ~isempty(args{3})
  constraints = subs(args{3}, fixedSymVars, fixedSymVals);

  if ~autoMode
    % Check that the constraints can be solved for the boundSymVars.
    % MuPAD raises an error if jacobian(subs(constraints,t,t0),boundSymVars)
    % is not of full rank:
    feval(symengine, 'daetools::isSolvable', constraints, boundSymVars, t0);
  end

  try 
    C = daeFunction(constraints, boundSymVars);
    [fixedVals0,~] = decic(C,double(t0),double(boundSymVals),[],zeros(r,1),ones(r,1),options);
    y0(fixedVars == 0) = fixedVals0;
  catch ME
    if strcmp(ME.identifier,'MATLAB:decic:TooManyFixed')
      error(message('symbolic:sym:decic:CannotResolveConstraints'));
    else
      rethrow(ME);
    end
  end
end

% A consistent initial condition y0 satisfying constraints(t0,y0)
% is found. Now, solve F(t0, y0, yp0) for yp0:
try 
  F = daeFunction(args{1}, args{2}); % F defines the DAE
  [y0,yp0] = decic(F,t0,y0,ones(n,1),yp0,[],options);
catch ME
  if strcmp(ME.identifier,'MATLAB:decic:TooManyFixed')
     error(message('symbolic:sym:decic:CannotFindConsistentInitConditions')); 
  else
     rethrow(ME);
  end
end
end

% ---------- utility --------------
function y = checkForNaNsAndInfs(x)
if any(~isfinite(x))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
else 
   y = x;
end
end

