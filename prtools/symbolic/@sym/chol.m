function [X,Y,Z] = chol(A,varargin)
% chol   Cholesky factorization.
%   R = chol(A) produces an upper triangular R so that R'*R = A if A is
%   a Hermitian positive definite matrix. If A is not Hermitian positive
%   definite, an error message is printed.
%
%   R = chol(A,'upper') returns the same result as R = chol(A).
%
%   L = chol(A,'lower') returns a lower triangular matrix L so that
%   L*L' = A. If A is not Hermitian positive definite, an error message
%   is printed.
%
%   [R,p] = chol(A), with two output arguments, does not error if A
%   is not Hermitian positive definite. If A is Hermitian positive
%   definite or option 'nocheck' is used, then p = 0 is returned. If A
%   is not recognized to be Hermitian positive definite, then p is a
%   positive integer and R is an upper triangular matrix of order q = p-1
%   so that R'*R = A(1:q,1:q).
%
%   [L,p] = chol(A,'lower'), works as described above, only a lower
%   triangular matrix L is produced.
%
%   [R,p,S] = chol(A) returns a permutation matrix S such that R'*R =
%   S'*A*S, when p = 0. If p is a positive integer (i.e., A is not
%   recognized to be Hermitian positive definite), S = sym([]) is
%   returned.
%
%   [R,p,s] = chol(A,'vector') returns the permutation information as
%   a vector s such that A(s,s) = R'*R, when p = 0. If p is a positive
%   integer (i.e., A is not recognized to be Hermitian positive definite),
%   s = sym([]) is returned. The flag 'matrix' may be used in place of
%   'vector' to obtain the default behavior.
%
%   [L,p,s] = chol(A,'lower','vector') returns a lower triangular
%   matrix L and a permutation vector s such that A(s,s) = L*L',
%   when p = 0. If p is a positive integer (i.e., A is not recognized to
%   be Hermitian positive definite), s = sym([]) is returned. As above,
%   'matrix' may be used in place of 'vector' to obtain a permutation
%   matrix.
%
%   R = chol(A,'nocheck') does not check whether A is Hermitian
%   positive definite at all. This option can be useful when A has
%   components containing symbolic parameters. In order to avoid having
%   to set all kind of assumptions to make SYM/CHOL realize that A is
%   Hermitian positive definite for all values of the parameters,
%   option 'nocheck' can be used. Note that when using option 'nocheck'
%   the identity R'*R = A may no longer hold if A is not Hermitian
%   positive definite!
%
%   R = chol(A,'real') uses real arithmetic. This option can be useful
%   when A has components containing symbolic parameters. In order to
%   avoid having to set all kind of assumptions to avoid complex
%   conjugates, option 'real' can be used.
%   The matrix A must either be symmetric or option 'nocheck' has to be
%   used additionally. Note that when using option 'real', the identity
%   R'*R = A in general will only hold for real symmetric positive
%   definite A.
%
%   See also CHOL, SYM/LU, SYM/SVD, SYM/EIG, SYM/VPA, ASSUME,
%   ASSUMEALSO.

%   Copyright 1993-2014 The MathWorks, Inc.

if ~isa(A,'sym')
    error(message('symbolic:sym:chol:FirstArgumentMustBeSYM'));
end

for i = 1:nargin-1
    try 
        varargin{i} = validatestring(varargin{i}, {'lower','upper','vector','matrix','nocheck','real'});
    catch err
        error(message('symbolic:sym:chol:InvalidArgument'));
    end
end

options = 'null()';

if any(strcmp('lower',varargin))
    options = [options ',"lower"'];
end

if any(strcmp('lower',varargin)) && any(strcmp('upper',varargin))
    error(message('symbolic:sym:chol:StringUpperOrLowerExpected'));
end

if any(strcmp('vector',varargin)) && any(strcmp('matrix',varargin))
    error(message('symbolic:sym:chol:StringVectorOrMatrixExpected'));
end

if any(strcmp('vector',varargin))
    if nargout < 3
        error(message('symbolic:sym:chol:VectorOnlySupportedInCaseOfThreeOutputs'));
    else
        options = [options ',"vector"'];
    end
end

if any(strcmp('matrix',varargin))
    if nargout < 3
        error(message('symbolic:sym:chol:MatrixOnlySupportedInCaseOfThreeOutputs'));
    else
        options = [options ',"matrix"'];
    end
end

if any(strcmp('nocheck',varargin))
    options = [options ',"noCheck"'];
end

if any(strcmp('real',varargin))
    options = [options ',"real"'];
end

if builtin('numel',A) ~= 1,  A = normalizesym(A);  end

sz = size(formula(A));
if sz(1)~=sz(2) || numel(sz) > 2
    error(message('symbolic:sym:chol:MatrixMustBeSquare'));
end

if any(~isfinite(formula(privsubsref(A,':'))))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if isempty(formula(A))
    X = A;
    Y = double(A);
    Z = double(A);
    return;
else
    [X,Y,Z] = mupadmexnout('symobj::chol',A,options);
    X = privResolveOutput(X,A);
    Y = double(Y);
    Z = double(Z);
    if nargout < 2 && Y == 1 && ~any(strcmp('nocheck',varargin))
        error(message('symbolic:sym:chol:MatrixNotHermitianPositiveDefinite'));
    end
end
