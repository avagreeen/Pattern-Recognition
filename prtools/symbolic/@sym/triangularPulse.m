function y = triangularPulse(varargin)
%TRIANGULARPULSE Triangular pulse function.
%   Y = TRIANGULARPULSE(X) is the symmetric triangular pulse over the 
%   interval from -1 to 1. 
%
%   Y = TRIANGULARPULSE(A,C,X) is the symmetric triangular pulse over the 
%   interval from A to C. 
%
%   Y = TRIANGULARPULSE(A,B,C,X) is the general triangular pulse over the 
%   interval from A to C with its maximum located at B. 
%
%   It is 0 if X <= A.
%   It is (X-A)/(B-A) if A <= X <= B.
%   It is (C-X)/(C-B) if B <= X <= C.
%   It is 0 if X >= C.
%
%   Example:
%      syms a x
%      triangularPulse(a-1, a+1, a+2, a-1) returns  0
%      triangularPulse(a-1, a+1, a+3, a+2) returns  1/2
%      triangularPulse(a-1, a+1, a+3, a+4) returns  0
%      triangularPulse(a-1, a+1, a+3, x)   returns  triangularPulse(a-1, a+1, a+3, x)
%
%   See also SYM/RECTPULSE.

if nargin ~= 1 && nargin ~= 3 && nargin ~= 4
  error(message('symbolic:sym:triangularPulse:WrongNumberOfArguments'));
end
args = privResolveArgs(varargin{:});
if nargin == 3 && (numel(args{1}) > 1 || numel(args{2}) > 1)
  error(message('symbolic:sym:triangularPulse:FirstTwoArgumentsMustBeScalar'));
end
if nargin == 4 && (numel(args{1})>1 || numel(args{2})>1 || numel(args{3})>1)
  error(message('symbolic:sym:triangularPulse:FirstThreeArgumentsMustBeScalar'));
end
refs = cellfun(@(x)x.s, args, 'UniformOutput', false);
ySym = mupadmex('symobj::vectorizeSpecfunc', refs{:}, 'triangularPulse', 'infinity');
y = privResolveOutput(ySym, args{1});

