function [V,J] = jordan(A)
%JORDAN Jordan Canonical Form.
%   JORDAN(A) computes the Jordan Canonical/Normal Form of the matrix A.
%   The matrix must be known exactly, so its elements must be integers
%   or ratios of small integers.  Any errors in the input matrix may
%   completely change its JCF.
%
%   [V,J] = JORDAN(A) also computes the similarity transformation, V, so
%   that V\A*V = J.  The columns of V are the generalized eigenvectors.
%
%   Example:
%      A = gallery(5);
%      [V,J] = jordan(A)
%
%   See also CHARPOLY, SYM/EIG, EIG, POLY

%   Copyright 1993-2014 The MathWorks, Inc.

oldDigits = digits(16);
cleanupObj = onCleanup(@() digits(oldDigits));

if nargout < 2
   V = cast(jordan(sym(A)),'like',A);
else
   [V,J] = jordan(sym(A));
   V = cast(V,'like',A);
   J = cast(J,'like',A);
end
