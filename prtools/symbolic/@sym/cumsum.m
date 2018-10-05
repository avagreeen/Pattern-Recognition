function r = cumsum(varargin)
%CUMSUM   Symbolic cumulative sum of elements.
%   For vectors, CUMSUM(X) is a vector containing the cumulative sum of
%   the elements of SYM X. For matrices, CUMSUM(X) is a matrix the same 
%   size as X containing the cumulative sums over each column.  
%
%   CUMSUM(X,DIM) works along the dimension DIM.
%
%   CUMSUM(X,'reverse') and CUMSUM(X,DIM,'reverse') compute the cumulative
%   sum starting at the upper end of the index range.
%
%   Examples: 
%     X = sym([0, 1, 2; 3, 4, 5]); 
%
%     r = cumsum(X)
%     returns  r = [ 0, 1, 2; 3, 5, 7]
%
%     r = cumsum(X,2) 
%     returns  r = [ 0, 1, 3; 3, 7, 12]
%
%     syms x y; 
%     X = [x, 2*x+1, 3*x+2; 1/y, y, 2*y];
%  
%     r = cumsum(X)
%     returns r = [x, 2*x+1, 3*x+2; x+1/y, 2*x+y+1, 3*x+2*y+2]
%
%     r = cumsum(X,'reverse')
%     returns r = [x+1/y, 2*x+y+1, 3*x+2*y+2; 1/y, y, 2*y]
%
%     r = cumsum(X,2) 
%     returns r = [x, 3*x+1, 6*x+3; 1/y, y+1/y, 3*y+1/y]
%
%     r = cumsum(X,2,'reverse')
%     returns r = [6*x+3, 5*x+3, 3*x+2; 3*y+1/y, 3*y, 2*y]
%
%   See also CUMPROD, PROD, SUM, SYMPROD, SYMSUM, SYM/INT.

%   Copyright 2012-2014 The MathWorks, Inc.

narginchk(1,3);
r = cumsumprod('_plus', varargin{:});
