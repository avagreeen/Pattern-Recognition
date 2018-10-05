function Y = isAlways(X,varargin)
%isAlways     Test mathematical statement
%
%      isAlways(X) for a logical array X returns X.
%      This function exists to allow a uniform calling syntax for SYM and LOGICAL objects.

% Copyright 2013 The MathWorks, Inc.

% Note: @char/isAlways.m exists only to support isAlways(true,'Unknown','error') etc.

if ~islogical(X)
  error(message('MATLAB:categorical:UndefinedFunction', 'isAlways', class(X)));
end

Y = X;
