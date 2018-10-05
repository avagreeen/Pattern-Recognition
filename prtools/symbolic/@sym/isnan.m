function y = isnan(x)
%ISNAN  True for Not-a-Number for symbolic arrays.
%   ISNAN(X) returns an array that contains 1's where
%   the elements of X are symbolic NaN's and 0's where they are not.
%   For example, ISNAN(sym([pi NaN Inf -Inf])) is [0 1 0 0].
%
%   For any X, exactly one of ISFINITE(X), ISINF(X), or ISNAN(X)
%   is 1 for each element.
%
%   See also SYM/ISFINITE, SYM/ISINF.

x = privResolveArgs(x);
y = logical(feval(symengine, 'symobj::map', x{1}, 'stdlib::isnan'));
end
