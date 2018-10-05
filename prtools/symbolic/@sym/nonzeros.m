function B = nonzeros(A)
%NONZEROS non-zero entries of A

%   Copyright 2013 The MathWorks, Inc.

[~,~,B] = find(reshape(A, numel(A), 1));
B = reshape(B, numel(B), 1);
end
