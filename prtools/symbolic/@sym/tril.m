function Y = tril(X,offset)
%TRIL   Symbolic lower triangle.
%   TRIL(X) is the lower triangular part of X.
%   TRIL(X,K) is the elements on and below the K-th diagonal
%   of X .  K = 0 is the main diagonal, K > 0 is above the
%   main diagonal and K < 0 is below the main diagonal.
%
%   Examples:
%
%      Suppose
%      A =
%         [   a,   b,   c ]
%         [   1,   2,   3 ]
%         [ a+1, b+2, c+3 ]
%
%      then
%      tril(A) returns
%         [   a,   0,   0 ]
%         [   1,   2,   0 ]
%         [ a+1, b+2, c+3 ]
%
%      tril(A,1) returns
%         [   a,   b,   0 ]
%         [   1,   2,   3 ]
%         [ a+1, b+2, c+3 ]
%
%      tril(A,-1) returns
%         [   0,   0,   0 ]
%         [   1,   0,   0 ]
%         [ a+1, b+2,   0 ]
%
%   See also SYM/TRIU.

%   Copyright 2013-2014 The MathWorks, Inc.

if nargin == 1
    offset = 0; 
elseif isa(offset, 'sym')
    offset = double(offset);
    Y = tril(X, double(offset));
    return;   
elseif ~isscalar(offset) || ...
       ~(isnumeric(offset) && round(offset) == offset && isreal(offset))
    error(message('MATLAB:diag:kthDiagInputNotInteger'));
end

Y = privUnaryOp(X, 'symobj::tril', num2str(offset));
end
