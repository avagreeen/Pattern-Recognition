function r = cumprod(varargin)
%CUMPROD   Symbolic cumulative product of elements.
%   For vectors, CUMPROD(X) is a vector containing the cumulative product
%   of the elements of SYM X.  For matrices, CUMPROD(X) is a matrix the 
%   same size as X containing the cumulative products over each column.  
%
%   CUMPROD(X,DIM) works along the dimension DIM.
%
%   CUMPROD(X,'reverse') and CUMPROD(X,DIM,'reverse') compute the cumulative
%   product starting at the upper end of the index range.
%
%   Example: 
%     X = sym([0, 1, 2; 3, 4, 5]);
%
%     r = cumprod(X)  
%     returns  r = [0, 1, 2; 0, 4, 10]
%
%     r = cumprod(X,2) 
%     returns  r = [0, 0, 0; 3, 12, 60]
%
%     syms x y; 
%     X = [x, 2*x+1, 3*x+2; 1/y, y, 2*y];
%  
%     r = cumprod(X)
%     returns r = [x, 2*x+1, 3*x+2; x/y, y*(2*x+1), 2*y*(3*x+2)]
%
%     r = cumprod(X,'reverse')
%     returns r = [x/y, y*(2*x+1), 2*y*(3*x+2); 1/y, y, 2*y]
%
%     r = cumprod(X,2)
%     returns r = [x, x*(2*x+1), x*(2*x+1)*(3*x+2); 1/y, 1, 2*y]
%
%     r = cumprod(X,2,'reverse')
%     returns r = [x*(2*x+1)*(3*x+2), (2*x+1)*(3*x+2), 3*x+2; 2*y, 2*y^2, 2*y]
%
%   See also CUMSUM, PROD, SUM, SYMPROD, SYMSUM, SYM/INT. 

%   Copyright 2012-2014 The MathWorks, Inc.

narginchk(1,3);
r = cumsumprod('_mult', varargin{:});
