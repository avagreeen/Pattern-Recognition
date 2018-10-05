function y = horzcat(varargin)
%HORZCAT Horizontal concatenation for sym arrays.
%   C = HORZCAT(A, B, ...) horizontally concatenates the sym arrays A,
%   B, ... .  For matrices, all inputs must have the same number of rows.  For
%   N-D arrays, all inputs must have the same sizes except in the second
%   dimension.
%
%   C = HORZCAT(A,B) is called for the syntax [A B].
%
%   See also VERTCAT.

%   Copyright 2008-2011 The MathWorks, Inc.

args = privResolveArgs(varargin{:});
strs = cellfun(@(x)x.s,args,'UniformOutput',false);
try
    ySym = mupadmex('(symobj::extractscalar@symobj::horzcat)',strs{:});
catch
    ySym = cat(2,args{:});
end
y = privResolveOutput(ySym, args{1});
