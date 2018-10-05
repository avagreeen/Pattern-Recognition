function y = rectangularPulse(varargin)
%RECTANGULARPULSE Rectangular pulse function.
%   Y = RECTANGULARPULSE(X) is the rectangular pulse
%   over the interval from -1/2 to 1/2.
%
%   Y = RECTANGULARPULSE(A,B,X) is the rectangular pulse
%   over the interval from A to B.
%
%   It is 1 if A < X < B.
%   It is 0 if X < A or X > B or A = B.
%   It is 1/2 if A < B and X = A or X = B.
%
%   Example:
%      rectangularPulse(-1, 2, -3)    returns  0
%      rectangularPulse(-1, 2, 0.5)   returns  1
%      rectangularPulse(-1, 2, 2)     returns  0.5
%      rectangularPulse(-1, 2, 3)     returns  0
%      syms a x
%      rectangularPulse(a, a+2, a-1)  returns  0
%      rectangularPulse(a, a+2, a)    returns  1/2
%      rectangularPulse(a, a+2, a+1)  returns  1
%      rectangularPulse(a, a+2, a+2)  returns  1/2
%      rectangularPulse(a, a+2, a+3)  returns  0
%      rectangularPulse(a, a+2, x)    returns  rectangularPulse(a, a+2, x)
%
%   See also TRIANGULARPULSE.

%   Copyright 2012 The MathWorks, Inc.
narginchk(1,3);
y = sym.useSymForNumeric(@rectangularPulse, varargin{:});
