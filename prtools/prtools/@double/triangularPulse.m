function y = triangularPulse(varargin)
%   Y = TRIANGULARPULSE(X) is the symmetric triangular pulse
%   over the interval from -1 to 1.
%
%   Y = TRIANGULARPULSE(A,C,X) is the symmetric triangular pulse
%   over the interval from A to C.
%
%   Y = TRIANGULARPULSE(A,B,C,X) is the general triangular pulse
%   over the interval from A to C with its maximum at B.
%
%   It is 0 if X <= A.
%   It is (X-A)/(B-A) if A <= X <= B.
%   It is (C-X)/(C-B) if B <= X <= C.
%   It is 0 if X >= C.
%
%   Example:
%      triangularPulse(-2, 0, 3, -4)       returns  0
%      triangularPulse(-2, 0, 3,  0)       returns  1
%      triangularPulse(-2, 0, 3,  2)       returns  0.3333
%      triangularPulse(-2, 0, 3,  3)       returns  0
%      syms a x
%      triangularPulse(a-1, a+1, a+2, a-1) returns  0
%      triangularPulse(a-1, a+1, a+3, a+2) returns  1/2
%      triangularPulse(a-1, a+1, a+3, a+4) returns  0
%      triangularPulse(a-1, a+1, a+3, x)   returns  triangularPulse(a-1, a+1, a+3, x)
%
%   See also RECTANGULARPULSE.

%   Copyright 2012 The MathWorks, Inc.
narginchk(1,4);
y = sym.useSymForNumeric(@triangularPulse, varargin{:});
