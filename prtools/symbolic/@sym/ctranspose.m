function B = ctranspose(A)
%CTRANSPOSE Symbolic matrix complex conjugate transpose.
%   CTRANSPOSE(A) overloads symbolic A' .
%
%   Example:
%      [a b; 1-i c]' returns  [ conj(a),     1+i]
%                             [ conj(b), conj(c)].
%
%   See also SYM/TRANSPOSE.

%   Copyright 2013 The MathWorks, Inc.

B = privUnaryOp(A, 'symobj::ctranspose');
end
