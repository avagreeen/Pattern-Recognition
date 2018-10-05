function r = symprod(varargin)
%SYMPROD Symbolic product.
%   SYMPROD(f) evaluates the product of a series, where expression f 
%   defines the terms of a series, with respect to the default symbolic 
%   variable defaultVar determined by symvar. The value of the default 
%   variable changes from 1 to defaultVar. If f is a constant, the product
%   is with respect to 'x'.
%
%   SYMPROD(f,x) evaluates the product of a series, where expression f 
%   defines the terms of a series, with respect to the symbolic variable x. 
%   The value of the variable x changes from 1 to x.
%
%   SYMPROD(f,a,b) evaluates the product of a series, where expression f 
%   defines the terms of a series, with respect to the default symbolic 
%   variable defaultVar determined by symvar. The value of the default       
%   variable changes from a to b. Specifying the range from a to b can       
%   also be done using a row or column vector with two elements, i.e.,       
%   valid calls are also SYMPROD(f,[a,b]) or SYMPROD(f,[a b]) and            
%   SYMPROD(f,[a;b]). 
%
%   SYMPROD(f,x,a,b) evaluates the product of a series, where expression f
%   defines the terms of a series, with respect to the symbolic variable x.
%   The value of the variable x changes from a to b. Specifying the range
%   from a to b can also be done using a row or column vector with two 
%   elements, i.e., valid calls are also SYMPROD(f,x,[a,b]) or 
%   SYMPROD(f,x,[a b]) and SYMPROD(f,x,[a;b]).
%
%   Examples:
%      syms l k n
%      symprod(k)                            factorial(k)
%      symprod(k,1,n)                        factorial(n)
%      symprod(k,[1,n])                      factorial(n)
%      symprod('1/k*l',l,1,n)                (k*factorial(n))/k^(n + 1)
%      symprod(1/k*l,l,1,n)                  (k*factorial(n))/k^(n + 1)
%      symprod(1/k*l,l,[1,n])                (k*factorial(n))/k^(n + 1)
%      symprod(l^2/(l^2 - 1), l, 2, Inf)     2 
%
%   See also SYM/INT, SYM/SYMSUM.

%   Copyright 1993-2015 The MathWorks, Inc.

narginchk(1,4);
[f, x, a, b] = parseFunctionVariableBounds(varargin{:});
args = privResolveArgs(f);
fsym = args{1}; 
indefinite = isempty(a);

if ~sym.isVariable(x) 
    if isnumeric(x)
        x = num2str(x);
    end
    error(message('symbolic:sym:symprod:InvalidProductIndex', char(x)));  
elseif ~isempty(a) 
    if ~isscalar(a) 
        error(message('symbolic:sym:symprod:InvalidLowerProductIndex'));
    elseif ~isscalar(b) 
        error(message('symbolic:sym:symprod:InvalidUpperProductIndex'));
    end    
end

if indefinite
   % indefinite product 
   rSym = mupadmex('symobj::map',fsym.s,'symobj::symprod',x.s);
else
   rSym = mupadmex('symobj::map',fsym.s,'symobj::symprod',x.s,a.s,b.s);
end


if indefinite
   r = privResolveOutput(rSym, f);
else
   r = privResolveOutputAndDelete(rSym, f, x);
end    
