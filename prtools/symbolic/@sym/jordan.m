function [V,J] = jordan(A)
%JORDAN   Jordan canonical form.
%   JORDAN(A) computes the Jordan canonical/normal form of the matrix A.
%   The matrix must be known exactly, so its elements must be integers,
%   or ratios of small integers.  Any errors in the input matrix may
%   completely change its JCF.
%
%   [V,J] = JORDAN(A) also computes the similarity transformation, V, so
%   that V\A*V = J.  The columns of V are the generalized eigenvectors.
%
%   Example:
%      A = sym(gallery(5));
%      [V,J] = jordan(A)
%
%   See also SYM/EIG, CHARPOLY.

%   Copyright 1993-2011 The MathWorks, Inc.

if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
if any(~isfinite(privsubsref(A,':')))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf')); 
elseif all(size(formula(A)) == 1)
   if nargout <= 1
      V = A;
   else
      J = A;
      V = sym(1);
   end
else
    if nargout <= 1
        Vsym = mupadmex('symobj::jordan',A.s);
        V = privResolveOutput(Vsym, A);
    else
        [Vsym,Jsym] = mupadmexnout('symobj::jordan',A,'All');
        V = privResolveOutput(Vsym, A);
        J = privResolveOutput(Jsym, A);
    end
end

