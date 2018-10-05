function C = mod(A,B)
%MOD    Symbolic modulus after division.
%   MOD(x,y) is x - n.*y where n = floor(x./y) if y ~= 0.  If y is not an
%   integer and the quotient x./y is within roundoff error of an integer,
%   then n is that integer.  The inputs x and y must be real arrays of the
%   same size, or real scalars.
%
%   Examples:
%      ten = sym('10');
%      mod(2^ten,ten^3)
%      24
%
%
%   See also SYM/REM.

%   Copyright 1993-2014 The MathWorks, Inc.

C = privBinaryOp(A, B, 'symobj::zip', 'symobj::modp');
