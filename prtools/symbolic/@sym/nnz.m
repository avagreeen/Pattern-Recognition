function n = nnz(A)
%NNZ Number of NonZero entries

%   Copyright 2013 The MathWorks, Inc.

n = str2double(mupadmex('symobj::nnz', A.s, 0));
end
