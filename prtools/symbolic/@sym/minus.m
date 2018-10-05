function X = minus(A, B)
%MINUS  Symbolic subtraction.
%   MINUS(A,B) overloads symbolic A - B.
    
%   Copyright 1993-2011 The MathWorks, Inc.

X = privBinaryOp(A, B, 'symobj::zip', '_subtract');
