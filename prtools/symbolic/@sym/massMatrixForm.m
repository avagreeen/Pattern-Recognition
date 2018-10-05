function [M, F] = massMatrixForm(eqs, vars)
%MASSMATRIXFORM  Extract the mass matrix and the 'right side' of a 
%    semi-linear system of symbolic differential algebraic equations
%    (DAEs).
%
%    [M, F] = massMatrixForm(eqs, vars)
%
%    A vector eqs of semi-linear symbolic first-order differential 
%    equations or expressions -- the latter interpreted as equations 
%    with zero right sides -- with 'state variables' given by a vector
%    vars of symbolic variables, univariate symbolic functions, or
%    univariate symbolic function calls, can be written in a unique
%    way as eqs == M(t,vars)*diff(vars)-F(t,vars)==0, where M is called
%    the 'mass matrix' of the system. Algebraic equations in eqs that
%    do not contain any derivatives of the variables in vars correspond
%    to empty rows of the mass matrix.
%
%    The output M of MASSMATRIXFORM is a symbolic matrix of size 
%    length(eqs) by length(vars). The output F is a symbolic column
%    vector with length(eqs) elements.
%
%    Example:
%      >> syms x1(t) x2(t) f(t,x1,x2) r m;
%         eqs = [m*x2(t)*diff(x1(t),t)+m*t*diff(x2(t),t)==f(t,x1(t),x2(t)),...
%                x1(t)^2+x2(t)^2==r^2];
%         vars = [x1(t),x2(t)];
%      >> [M, F] = massMatrixForm(eqs, vars)
%
%      M =
%           [ m*x2(t), m*t]
%           [       0,   0]
%
%      F =
%             f(t, x1(t), x2(t))
%        r^2 - x2(t)^2 - x1(t)^2
%      
%      Find a solution of this differential algebraic equation using the 
%      numerical solver ODE15s. First, convert convert both M and F to 
%      MATLAB function handles. Choose the numerical values m=100, r=1, and 
%      f(t,x1,x2)=t + x1*x2. The 'state variables' x1(t),x2(t) are replaced 
%      by simple names Y1,Y2 that are accepted by MATLABFUNCTION: 
%      >> syms Y1 Y2;
%         M = subs(M, [vars,m,r,f], [Y1,Y2,100,1,@(t,x1,x2) t+x1*x2]);
%         F = subs(F, [vars,m,r,f], [Y1,Y2,100,1,@(t,x1,x2) t+x1*x2]);
%      The function handles MM,FF are suitable input for ODESET and ODE15S.
%      Note that these functions expect the state variables to be column 
%      vectors:
%      >> MM = matlabFunction(M, 'vars', {t, [Y1; Y2]});
%         FF = matlabFunction(F, 'vars', {t, [Y1; Y2]});
%         opt = odeset('Mass', MM, 'InitialSlope', [0.005;0]);
%         ode15s(FF, [0,1], [0.5; 0.5*sqrt(3)], opt);
%
%   See also: MATLABFUNCTION, ODE15S, SUBS.

%   Copyright 2014 The MathWorks, Inc.

  narginchk(2,2);
  [eqs, vars] = checkDAEInput(eqs, vars);
  if isempty(eqs)
     M = sym(zeros(0, numel(vars)));
     F = sym(zeros(0, 1));
     return
  end
  if isempty(vars)
     M = sym(zeros(numel(eqs), 0));
     F = -eqs;
     return
  end
  [M,F] = mupadmexnout('symobj::massMatrixForm', eqs, vars);
end
