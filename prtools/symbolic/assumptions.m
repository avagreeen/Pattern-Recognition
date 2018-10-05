function y=assumptions(x)
%ASSUMPTIONS Show assumptions set on variable
%   ASSUMPTIONS(X) returns the symbolic array of assumptions on 
%   the symbolic variable X. If X is an array of symbolic variables, 
%   ASSUMPTIONS(X) returns all assumptions on all symbolic variables in X.
%
%   ASSUMPTIONS without any inputs returns the list of all assumptions
%   currently defined for all symbolic variables.
%
%   Example
%      syms x y
%      assume(x > y)
%      assumeAlso(x < 10)
%      assumptions
%        ans =
%        [y<x  x<10]
%
%   See also sym/assume, sym/assumeAlso

%   Copyright 2011 MathWorks, Inc.

if nargin == 0
    y=mupadmex('symobj::assumptions()');
else
    y=feval(symengine,'symobj::assumptions', sym(x));
end
