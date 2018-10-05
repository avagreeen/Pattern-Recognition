function F = transform(trans_func, x_default, w_default, v_default, f, varargin)
% 
%  Helper function to call one of MuPAD's transform functions:
%  trans_func is one of the strings 'fouier', 'laplace', 'ztrans', 
%         'ifourier', 'ilaplace', or 'iztrans'. 
%  x_default, w_default, v_default are strings representing the
%        default transform variable, the default output variable 
%        (the evaluation point of the transform function) and the 
%        default alternative output variable, respectively. 
%  f     is the sym or symfun that is to be transformed.
%  The optional 6th and 7th argument are the actual transform 
%  variable and the actual evaluation point of the transform function.
%
%  syms u y f(x);
%  transform('fourier','x','w','v',f(x))     produces fourier(f(x), x, w)
%  transform('fourier','x','w','v',f(x),u)   produces fourier(f(x), x, u)
%  transform('fourier','x','w','v',f(y),y,u) produces fourier(f(y), y, u)

%   Copyright 2013 The MathWorks, Inc.

narginchk(5, 7);
if ~isa(f, 'sym'), f = sym(f); end
x = sym(x_default); 
if nargin < 7
   if all(logical(symvar(f) ~= x))
      x = symvar(f,1);
      if isempty(x), x = sym(x_default); end
   end
   if nargin < 6
      if x ~= sym(w_default)
         w = sym(w_default);
      else
         w = sym(v_default);
      end
   end
end
if nargin == 6
   w = varargin{1};
   if ~isa(w, 'sym'), w = sym(w); end
elseif nargin == 7
   x = varargin{1};
   if ~isa(x, 'sym'), x = sym(x); end
   % check that x is an identifier/array of identifiers:
   if any(arrayfun(@(x) ~isequal(x, symvar(x, 1)), x))
      error(message('symbolic:sym:transform:ExpectingVariableNames2'));
   end
   w = varargin{2};
   if ~isa(w, 'sym'), w = sym(w); end
end
%----------------
% replace symfuns
%----------------
issymfun = isa(f, 'symfun');
if isa(w, 'symfun')
   error(message('symbolic:sym:transform:SymfunNotAccepted3', trans_func));
end
if issymfun
   fargs = argnames(f);
   % All second arguments must coincide. Otherwise,
   % the resulting symfun cannot be constructed:
   if ~isscalar(x) 
      tmp = logical(x ~= privsubsref(x, 1));
      if any(tmp(:))
        error(message('symbolic:sym:transform:VectorisationNotPossible2'));
      end
   end
   % Eliminate x from the arguments of the symfun
   fargs = privsubsref(fargs, logical(fargs ~= privsubsref(x, 1)));
   f = formula(f);
end
%------------------
% do the transform!
%------------------
F = mupadmex('symobj::vectorizeSpecfunc', f.s, x.s, w.s, trans_func, 'infinity');
% -------------------------
% re-vitalize symfuns
% -------------------------
if issymfun && ~isempty(fargs)
   F = symfun(F, fargs);
end
end
