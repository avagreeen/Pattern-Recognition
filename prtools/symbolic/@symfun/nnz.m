function n = nnz(A)
%NNZ Number of NonZero entries

%   Copyright 2013 The MathWorks, Inc.

if nnz(formula(A)) > 0
  n = 1;
else
  n = 0;
end
