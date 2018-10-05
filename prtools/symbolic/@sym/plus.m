function X = plus(A, B)
%PLUS   Symbolic addition.
%   PLUS(A,B) overloads symbolic A + B.
    
%   Copyright 1993-2011 The MathWorks, Inc.

X = privBinaryOp(A, B, 'symobj::zip', '_plus');
