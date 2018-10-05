function B = nonzeros(A)
%NONZEROS non-zero entries of A

%   Copyright 2013 The MathWorks, Inc.

if nnz(A) > 0
  B = A;
else
  B = sym(zeros(0,1));
end
end
