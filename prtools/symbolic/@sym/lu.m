function [L,U,P,Q,R] = lu(A,varargin)
%LU     LU factorization.
%   Y = lu(A) returns the matrix Y that contains the strictly lower 
%   triangular L, i.e., without its unit diagonal, and the upper  
%   triangular U as submatrices. That is, if [L,U,P] = lu(A), then 
%   Y = U+L-eye(size(A)).
%
%   [L,U] = LU(A) stores an upper triangular matrix in U and a permuted
%   lower triangular matrix in L, so that A = L*U. A can be
%   rectangular.
%
%   [L,U,P] = LU(A) returns a lower triangular matrix L, an upper
%   triangular matrix U, and a permutation matrix P so that P*A = L*U.
%
%   [L,U,p] = LU(A,'vector') returns the permutation information as a
%   vector instead of a matrix. That is, p is a row vector such that
%   A(p,:) = L*U. Similarly, [L,U,P] = LU(A,'matrix') returns a
%   permutation matrix P. This is the default behavior.
%
%   [L,U,p,q] = LU(A,'vector') returns two row vectors p and q so that
%   A(p,q) = L*U. Since the internal symbolic algorithms are based on row 
%   permutations only, the vector q always has entries 1,2,...,size(A,2). 
%   Using 'matrix' in place of 'vector' returns permutation matrices.
%
%   [L,U,P,Q,R] = LU(A) returns a lower triangular matrix L, an upper
%   triangular matrix U, permutation matrices P and Q, and a diagonal
%   scaling matrix R so that P*(R\A)*Q = L*U. Since the internal symbolic 
%   algorithms are based on row permutations only and do not make use of 
%   scaling, the matrices Q and R are always identity matrices. 
%
%   [L,U,p,q,R] = LU(A,'vector') returns the permutation information in two
%   row vectors p and q such that R(:,p)\A(:,q) = L*U. Using 'matrix'
%   in place of 'vector' returns permutation matrices.
%
%   Note that the optional argument THRESH supported by MATLAB's core 
%   function LU for numerical input is not supported by the symbolic 
%   obverload SYM/LU. 
%
%   Examples:
%       syms a;
%       A = [1, a; 1/2, 0; 1/5, 2; 2,-1];
%       [L,U,P,Q,R] = lu(A)
%       P*R*A*Q - L*U
%       [L,U,p,q,R] = lu(A,'vector')
%       R(:,p)\A(:,q) - L*U
%
%   See also LU, SYM/SVD, SYM/EIG, SYM/VPA.
  
%   Copyright 1993-2014 The MathWorks, Inc.

if nargin > 2 
    error(message('symbolic:sym:lu:TooManyInputArguments'));
end

p = inputParser;
p.addRequired('A', @(x) isa(x,'sym')); 
p.addOptional('opt', '', @(x) true);
p.parse(A,varargin{:});
A = p.Results.A;
opt = p.Results.opt;

if isempty(opt)
    opt = '"matrix"';
else
    try 
        opt = validatestring(opt, {'vector','matrix'});
    catch err
        error(message('symbolic:sym:lu:InvalidSecondArgument'));
    end
    opt = ['"' opt '"'];
end

if builtin('numel',A) ~= 1,  A = normalizesym(A);  end

if any(~isfinite(privsubsref(A,':')))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if isempty(A)
    Lsym = sym([]);
    Usym = sym([]);
    Psym = sym([]);
    Qsym = sym([]);
    Rsym = sym([]);
    pMatSym = sym([]);
else     
    [Lsym,Usym,Psym,Qsym,Rsym,pMatSym] = mupadmexnout('symobj::lu',A,opt);
end

L = privResolveOutput(Lsym, A);
U = privResolveOutput(Usym, A);
P = double(Psym);
Q = double(Qsym);
R = privResolveOutput(Rsym, A);
pMat = privResolveOutput(pMatSym, A);

if isa(A,'symfun') 
    s = size(formula(A));
else
    s = size(A);
end

if nargout == 2
    L = pMat.' * L;
elseif nargout <= 1 && s(1) == s(2) && length(s) == 2    
    L = U + tril(L,-1);
elseif nargout <= 1 && s(1) ~= s(2) && length(s) == 2   
    error(message('symbolic:sym:lu:InputMustBeSquareMatrix'));
end
