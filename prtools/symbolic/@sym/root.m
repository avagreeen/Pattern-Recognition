function r = root(f, x, k)
%ROOT    Roots of a polynomial expression
%   r = ROOT(f,x,k) represents the k-th root of the 
%   symbolic polynomial expression f, where x is a variable. 
%   Here, k is an integer (or a symbolic expression representing an integer) 
%   between 1 and the degree of f.
%   ROOT uses internal order when numbering polynomial roots. 
%   You cannot specify which polynomial root corresponds to a particular number k.
%
%   r = ROOT(f,x) returns a column vector containing all polynomial roots of f 
%   with respect to the variable x. 
%   The elements of r are root(f,x,1), ..., root(f,x,n).
%
%   See also SYM/SOLVE, ROOTS.

%   Copyright 2015 The MathWorks, Inc. 

f = sym(f);
if ~isscalar(formula(f))
   error(message('symbolic:sym:ExpectingScalar1')); 
end    
if nargin == 1 
    x = symvar(f, 1);
    if isempty(x)
        x = sym('x');
    end
elseif ~sym.isVariable(x)
    error(message('symbolic:sym:SymVariableExpected'));
end

if f == sym(0) 
   error(message('symbolic:rationalExpressions:FirstArgumentMustNotBeZero')); 
end    

if nargin <= 2 
    r = feval(symengine, 'RootOf', f, x);
    r = transpose(feval(symengine, 'expand', r, 'Recursive = FALSE'));
else
    r = feval(symengine, 'symobj::map', k, '(N, F, X) -> RootOf(F, X, N)', f, x);
end    
    