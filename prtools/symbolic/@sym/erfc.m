function Y = erfc(k,X)
% ERFC    Symbolic complementary error function.
%    ERFC(X) represents the complementary error function 1-ERF(X).
%
%    ERFC(k,X) with some integer k>-2 represents the iterated 
%    integrals of the complementary error function, i.e., 
%    ERFC(k,X) = int(ERFC(k-1,y),y,X,inf).
%
%   See also ERF, ERFI. 

% Copyright 2013 The MathWorks, Inc.

if nargin == 1
    X = k;
    k = sym(0);
end
Y = privBinaryOp(k, X, 'symobj::vectorizeSpecfunc', 'symobj::erfc', 'infinity');
end
