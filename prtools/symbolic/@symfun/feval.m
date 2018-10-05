function varargout = feval(F,varargin)
%FEVAL  Evaluate symbolic function
%   feval(F,x1,...,xn) evaluates the symbolic function F
%   at the given arguments x1, ..., xn. If any of the
%   arguments are matrices or n-dimensional arrays the
%   function is vectorized over the matrix elements. The
%   syntax F(x1...xn) is equivalent to feval(F,x1...xn).
%
%   If the body of F is nonscalar and any of the inputs
%   is nonscalar then the output is a cell array the
%   shape of the body of F and each element is the
%   evaluation of the corresponding element of the body
%   of F.

%   Copyright 2011-2013 The MathWorks, Inc.

if ~isa(F,'symfun')
    [varargout{1:nargout}] = builtin('feval',F,varargin{:});
    return;
end

nargoutchk(1,1);

Fvars = reshape(privToCell(F.vars), 1, []);
cc = mupadmex('symobj::size', F.s, 0);
siz = eval(cc);
if prod(siz) == 1 || all(cellfun(@isscalar,varargin))
    varargout{1} = evalScalarFun(F, Fvars, varargin);
else
    varargout{1} = evalMatrixFun(siz, F, Fvars, varargin);
end

function y = evalMatrixFun(siz, F, Fvars, inds)
y = cell(siz);
N = prod(siz);
Ffun = arrayfun(@(x) x,formula(F),'UniformOutput',false);
for k=1:N
    y{k} = evalScalarFun(Ffun{k}, Fvars, inds);
end

function y = evalScalarFun(Ffun, Fvars, inds)
y = subs(formula(Ffun), Fvars, inds);
