function logic = isLowIndexDAE(eqs, vars)
%ISLOWINDEXDAE  Test if a first-order system of differential algebraic 
%   equations (DAEs) is of low differential index (0 or 1).
%
%   Y = isLowIndexDAE(eqs, vars)
%   returns the logical 1 (true), when the differential index of the
%   semi-linear DAE given by the symbolic vector eqs with the state
%   variables given by the vector vars is 0 or 1. If the differential
%   index is higher than 1, then it returns the logical 0 (false).
%   The DAE must be of first order and semi-linear. Otherwise,
%   ISLOWINDEXDAE throws an error. The number of equations must 
%   coincide with the number of variables.
%
%   Example 1:
%     >> syms  x(t) y(t);
%        eqs = [diff(x)==x+y, x^2+y^2==1];
%        vars = [x, y];
%        isLowIndexDAE(eqs, vars) % returns true.
%
%   Example 2:
%     The following DAE contains an arbitrary function f(t) that
%     is a parameter, not a state variable:
%
%     >> syms  x(t) y(t) z(t) f(t);
%        eqs = [diff(x)==x+z, diff(y)==f(t), x==y];
%        vars = [x, y, z];
%        isLowIndexDAE(eqs, vars) % returns false (0). 
%
%    ISLOWINDEXDAE does not return the value of the differential index 
%    of the DAE system. To compute this value, call REDUCEDAEINDET with
%    four output arguments:
%
%    >> [~,~,~,index] = reduceDAEIndex(eqs, vars)
%
%       index =
%
%       2
%
%   See also:  SYM/REDUCEDAEINDEX, SYM/REDUCEDAETOODE.

%   Copyright 2014 The MathWorks, Inc.

  narginchk(2,2);
  [eqs, vars] = checkDAEInput(eqs, vars);
  if numel(eqs) ~= numel(vars)
    error(message('symbolic:daeFunction:ExpectingAsManyEquationsAsVariables'));
  end
  logic = logical(feval(symengine, 'daetools::isLowIndexDAE', eqs, vars));
end
