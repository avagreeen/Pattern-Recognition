function Q = orth(A,varargin)
%ORTH   Orthogonalization.
%   Q = ORTH(A) is an orthonormal basis for the range of A.
%   That is, Q'*Q = I, the columns of Q span the same space as
%   the columns of A, and the number of columns of Q is the
%   rank of A.
%
%   Q = ORTH(A,'real') uses a real scalar product in the orthogonalization
%   process.
%
%   Q = ORTH(A,'skipnormalization') provides an orthogonal basis which is
%   not normalized (i.e., vectors do not have length 1).
%
%   See also ORTH, SYM/SVD, SYM/RANK, SYM/NULL.

%   Copyright 1984-2014 The MathWorks, Inc.

if ~isa(A,'sym')
    error(message('symbolic:sym:orth:FirstArgumentMustBeSYM'));
end

for i = 1:nargin-1
    try 
        varargin{i} = validatestring(varargin{i}, {'real','skipnormalization'});
    catch err
        error(message('symbolic:sym:orth:InvalidArguments'));
    end
end

options = 'null()';

if any(strcmp('real',varargin))
    options = [options ',"Real"'];
end

if any(strcmp('skipnormalization',varargin))
    options = [options ',"skipNormalization"'];
end

if builtin('numel',A) ~= 1,  A = normalizesym(A);  end

if any(~isfinite(privsubsref(A,':')))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if isempty(formula(A))
    Q = sym(zeros(size(formula(A),1),0));
else
    Q = mupadmex('symobj::orth',A.s,options);
end
Q = privResolveOutput(Q,A);
