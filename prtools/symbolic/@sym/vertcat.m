function y = vertcat(varargin)
%VERTCAT Vertical concatenation for sym arrays.
%   C = VERTCAT(A, B, ...) vertically concatenates the sym arrays A,
%   B, ... .  For matrices, all inputs must have the same number of columns.
%   For N-D arrays, all inputs must have the same sizes except in the first
%   dimension.
%
%   C = VERTCAT(A,B) is called for the syntax [A; B].
%
%   See also HORZCAT.

%   Copyright 2008-2011 The MathWorks, Inc.

args = privResolveArgs(varargin{:});
strs = cellfun(@(x)x.s,args,'UniformOutput',false);
try
    ySym = mupadmex('(symobj::extractscalar@symobj::vertcat)',strs{:});
catch
    ySym = cat(1,args{:});
end
y = privResolveOutput(ySym, args{1});
