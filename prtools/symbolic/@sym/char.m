function M = char(A)
%CHAR   Convert scalar or array sym to string.
%   CHAR(A) returns a string representation of the symbolic object A
%   in MuPAD syntax.

%   Copyright 1993-2014 The MathWorks, Inc.

if builtin('numel',A) ~= 1
    A = normalizesym(A);
end

M = mupadmex('symobj::char', A.s, 0);

if strncmp(M,'"',1)
    M = M(2:end-1);  % remove quotes
end
