function B = transpose(A)
%TRANSPOSE Symbolic matrix transpose.
%   TRANSPOSE(A) overloads symbolic A.' .
%
%   Example:
%      [a b; 1-i c].' returns [a 1-i; b c].
%
%   See also SYM/CTRANSPOSE.

%   Copyright 2013 The MathWorks, Inc.

B = privUnaryOp(A, 'symobj::transpose');
end
