function c = norm(A,varargin)
% norm   Norm of a symbolic matrix or vector
% 
%  For a symbolic matrix A 
%      norm(A) returns the 2-norm of A. This is the same result as 
%              returned by norm(A,2). 
%      norm(A,1) returns the 1-norm of A.   
%      norm(A,2) returns the 2-norm of A.
%      norm(A,Inf) returns the Infinity norm of A. 
%      norm(A,'fro') returns the Frobenius norm of A. 
% 
%  For a symbolic vector v 
%      norm(v,p) returns the p-norm of the vector v. Here p can be  
%                any number.  
%      norm(v,Inf) returns the largest element of abs(v). 
%      norm(v,-Inf) returns the smallest element of abs(v).   
%
%   Examples: 
%      syms x y z a b c d; 
%      A = [a b; c d]; 
%      v = [a; b; c];
%
%      norm(A)
%      norm(A,1)
%      norm(A,Inf)
%      norm(A,'fro')
%
%      norm(v,2)
%      norm(v,Inf)
%      norm(v,-Inf)
%
%   See also cond, inv, norm, rank.
  
%   Copyright 2012-2014 The MathWorks, Inc.

Input = inputParser;
Input.addRequired('A', @(x) isa(A,'sym')); 
Input.addOptional('p', 2, @(x) isa(sym(x),'sym')); 
Input.parse(A,varargin{:});
A = Input.Results.A;
p = Input.Results.p;

if builtin('numel',A) ~= 1,  A = normalizesym(A);  end

if ~isscalar(sym(p))
    error(message('symbolic:sym:norm:InvalidMatrixNorm'));
end
if ischar(p)
    try 
        p = validatestring(p, {'fro','inf'});
    catch err
        error(message('symbolic:sym:norm:InvalidMatrixNorm'));
    end
end
if isempty(A) 
    c = sym(0);
elseif p == 1  
    c = privBinaryOp(A,sym(1),'symobj::norm');
elseif p == 2 
    c = privBinaryOp(A,sym(2),'symobj::norm');
elseif ischar(p) && strcmp(p,'fro') 
    c = privBinaryOp(A,sym('Frobenius'),'symobj::norm');
elseif (ischar(p) && strcmp(p,'inf')) || p == inf
    c = privBinaryOp(A,sym('Infinity'),'symobj::norm');
elseif p == -inf 
    c = privBinaryOp(A,-sym('Infinity'),'symobj::norm');
else 
    c = privBinaryOp(A,sym(p),'symobj::norm');
end
