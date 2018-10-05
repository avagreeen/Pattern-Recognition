function X = inv(A)
%INV    Symbolic matrix inverse.
%   INV(A) computes the symbolic inverse of A
%   INV(VPA(A)) uses variable precision arithmetic.
%
%   Examples:
%      Suppose B is
%         [ 1/(2-t), 1/(3-t) ]
%         [ 1/(3-t), 1/(4-t) ]
%
%      Then inv(B) is
%         [     -(-3+t)^2*(-2+t), (-3+t)*(-2+t)*(-4+t) ]
%         [ (-3+t)*(-2+t)*(-4+t),     -(-3+t)^2*(-4+t) ]
%
%      digits(10);
%      inv(vpa(sym(hilb(3))));
%
%   See also VPA.

%   Copyright 2013 The MathWorks, Inc.

X = privUnaryOp(A, 'symobj::inv');
end
