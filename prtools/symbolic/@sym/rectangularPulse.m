function y = rectangularPulse(varargin)
%RECTANGULARPULSE Rectangular pulse function.
%   Y = RECTANGULARPULSE(X) is the rectangular pulse over the 
%   interval from -1/2 to 1/2. 
%
%   Y = RECTANGULARPULSE(A,B,X) is the rectangular pulse over the 
%   interval from A to B. 
%
%   It is 1 if A < X < B. 
%   It is 0 if X < A or X > B or A = B. 
%   It is 1/2 if A < B and X = A or X = B.
%
%   Example:
%      syms a x
%      rectangularPulse(a, a+2, a-1)  returns  0
%      rectangularPulse(a, a+2, a)    returns  1/2
%      rectangularPulse(a, a+2, a+1)  returns  1
%      rectangularPulse(a, a+2, a+2)  returns  1/2
%      rectangularPulse(a, a+2, a+3)  returns  0
%
%   See also SYM/TRIANGULARPULSE.

if nargin ~= 1 && nargin ~= 3 
  error(message('symbolic:sym:rectangularPulse:WrongNumberOfArguments'));
end
args = privResolveArgs(varargin{:});
if nargin == 3 && (numel(args{1}) > 1 || numel(args{2}) > 1)
  error(message('symbolic:sym:rectangularPulse:FirstTwoArgumentsMustBeScalar'));
end
refs = cellfun(@(x)x.s, args, 'UniformOutput', false);
ySym = mupadmex('symobj::vectorizeSpecfunc', refs{:}, 'rectangularPulse', 'infinity');  
y = privResolveOutput(ySym, args{1});

