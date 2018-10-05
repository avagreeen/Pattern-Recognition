function Y = triu(X,offset)
%TRIU   Symbolic upper triangle.
%   TRIU(X) is the upper triangular part of X.
%   TRIU(X,K) is the elements on and above the K-th diagonal of
%   X.  K = 0 is the main diagonal, K > 0 is above the main
%   diagonal and K < 0 is below the main diagonal.
%
%   Examples:
%
%      Suppose
%         A =
%            [   a,   b,   c ]
%            [   1,   2,   3 ]
%            [ a+1, b+2, c+3 ]
%
%      then
%         triu(A) returns
%            [   a,   b,   c ]
%            [   0,   2,   3 ]
%            [   0,   0, c+3 ]
%
%         triu(A,1) returns
%            [ 0, b, c ]
%            [ 0, 0, 3 ]
%            [ 0, 0, 0 ]
%
%         triu(A,-1) returns
%            [   a,   b,   c ]
%            [   1,   2,   3 ]
%            [   0, b+2, c+3 ]
%
%   See also SYM/TRIL.

%   Copyright 2013-2014 The MathWorks, Inc.

if nargin == 1
    offset = 0;
elseif isa(offset, 'sym')
    Y = triu(X, double(offset));
    return;
elseif ~isscalar(offset) || ...
       ~(isnumeric(offset) && round(offset) == offset && isreal(offset))
    error(message('MATLAB:diag:kthDiagInputNotInteger'));
end

Y = privUnaryOp(X, 'symobj::triu', num2str(offset));
end
