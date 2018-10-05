function f = daeFunction(eqs, vars, varargin)
%DAEFUNCTION   Convert a system of symbolic first-order differential 
%   algebraic equations (DAEs) to a MATLAB function handle that can serve
%   as input argument to a numerical MATLAB DAE solver, such as ODE15i.  
%
%   f = daeFunction(eqs, vars, options)
%   f = daeFunction(eqs, vars, p1, p2, ..., options)
%
%   eqs is a vector of symbolic equations or expressions -- the latter 
%   being interpreted as equations with zero right side --  in the variables 
%   given by the vector vars, which consists of symbolic variables, 
%   univariate symbolic functions, or univariate symbolic function 
%   calls. The equations eqs are regarded as a system of differential 
%   algebraic equations for the variables (functions) given in vars. 
% 
%   If eqs contains symbolic parameters beyond the variables given in vars,
%   they must be passed as additional arguments p1,p2,... to DAEFUNCTION.
%   These parameters can be symbolic variables, univariate or multivariate
%   symbolic functions, or univariate or multivariate symbolic function 
%   calls.
%
%   The optional arguments options can consist of all name-value pairs
%   accepted by the routine MATLABFUNCTION, apart from the name-value pair
%   associated with the option name 'vars'. These options are internally
%   passed to a call of MATLABFUNCTION and have the same effect as 
%   described in the documentation of MATLABFUNCTION.
%
%   The output f is a function handle to a function f(t,Y,YP,p1,p2,...).
%   The scalar input parameter t represents the 'time' variable: it is the
%   argument on which the (univariate) symbolic functions or symbolic 
%   function calls in the input argument vars depend.
%   The column vector Y represents the state variables (functions of 'time') 
%   given by the input argument vars.
%   The column vector YP represents the first 'time' derivatives of the 
%   state variables.
%   The arguments p1,p2,... represent the symbolic input parameters 
%   p1,p2,... of the call to DAEFUNCTION.
% 
%   Given numerical values v1,v2,... for the symbolic parameters p1,p2,...,
%   the reduced function handle
%     F = @(t,Y,YP) f(t,Y,YP,v1,v2,...)
%   represents the DAE given by eqs by F(t,Y,YP) = 0. The reduced function 
%   handle F is suitable as the first argument to ODE15I. 
%
%   Example:
%     Consider the following DAE:
%
%     >> syms x1(t) x2(t) a b r(t);
%        eqs = [diff(x1(t),t) == a*x1(t) + b*x2(t)^2, ... 
%               x1(t)^2 + x2(t)^2 == r(t)^2];
%        vars = [x1(t), x2(t)]
%
%     for the state variables given by the functions x(t),y(t), involving
%     the parameters a,b and the parameter function r(t). Generate a
%     function handle depending on the variables x1,x2 as well as the
%     parameters:
%
%     >> f = daeFunction(eqs,vars,a,b,r(t)) 
%   
%     The reduced function handle for the following parameter values 
%
%     >> a = -0.6;
%        b = -0.1;
%        r = @(t) cos(t)/(1 + t^2);
%
%     is given by
%
%     >> F = @(t, Y, YP) f(t,Y,YP,a,b,r(t));
%
%     Consistent initial conditions for the DAE system are given by
%
%     >> t0 = 0;
%        y0 = [-r(t0)*sin(0.1); r(t0)*cos(0.1)];
%        yp0= [a*y0(1) + b*y0(2)^2; 1.234];
%
%     Call ODE15I with these initial conditions, using the function
%     handle f: 
%
%     >> ode15i(F, [t0, 1], y0, yp0)
%         
% See also: ODE15I.

%   Copyright 2014-2015 The MathWorks, Inc.

  narginchk(2, Inf);
  if isa(eqs,'symfun')
    eqs = formula(eqs);
  end

  isvect = isvector(eqs);
  s = size(eqs);

  [eqs, vars] = checkDAEInput(eqs, vars);
  if numel(eqs) ~= numel(vars)
     error(message('symbolic:daeFunction:ExpectingAsManyEquationsAsVariables'));
  end

  % Look for the position of the first string argument.
  % This is where the matlabFunction options should start:
  flagpos = find(cellfun(@(x) ischar(x),varargin),1);
  if isempty(flagpos)
     params = varargin;
     matlabFunOptions = {};
  else
     params = varargin(1:flagpos-1);
     matlabFunOptions = varargin(flagpos:end);
  end
  % Do not allow the name 'vars' in the matlabFunction options:
  if any(cellfun(@(x) ischar(x) && ...
     ~isempty(regexpi(x,'^(v|va|var|vars)$')),matlabFunOptions(1:2:end)))
     error(message('symbolic:daeFunction:UnexpectedVars'));
  end
  
  % check that the parameters are syms
  params = cellfun(@sym, params, 'UniformOutput', false);
  
  A = feval(symengine, 'daetools::daeFunction', eqs, vars, params{:});
  A = num2cell(A);

  eqs = A{1}.';
  % if eqs is a matrix (e.g., the mass matrix),
  % then we need to restore the matrix form:
  if ~isvect
    eqs = reshape(eqs, s);
  end 
  
  if numel(params) == 1
      A{5} = A(5);
  else
      A{5} = num2cell(A{5});
  end

  varsAndParams = [{A{2}, A{3}.', A{4}.'} A{5}];
  f = matlabFunction(eqs, 'vars', varsAndParams, matlabFunOptions{:});
end
