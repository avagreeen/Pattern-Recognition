function B = children(A)
%CHILDREN   Child expressions of symbolic expression
%    Y = CHILDREN(X) returns the parts of expression X
%    as an array. For example, the children of a sum are the terms.
%    If X is not a scalar array then Y is a cell array of the
%    same size as X. The elements of Y contain the children of
%    the corresponding elements of X.
%
%    Examples
%      syms x y
%      children(x^2+y^2)
%      ans =
%      x^2    y^2
%      children(x^2 == y^2)
%      ans =
%      x^2    y^2
%
%    See also SYM, SYM/COEFFS

%   Copyright 2011-2013 The MathWorks, Inc.

Asym = privResolveArgs(A);
A = Asym{1};
fA = formula(A);
sz = size(fA);
if prod(sz) == 1
    B = mupadmex('symobj::children',A.s);
else
    B = cell(sz);
    n = numel(B);
    for k=1:n
        B{k} = mupadmex('(symobj::children@symobj::subsref)',A.s,num2str(k));
    end
end
