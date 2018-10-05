function [varargout] = size(x, dim)
%SIZE Size of a symfun array.

%   Copyright 2011-2014 The MathWorks, Inc.

if ~isa(x, 'symfun')
% overloading by second argument
    [varargout{1:nargout}] = size(x, double(dim));
    return
end
    
if nargin > 1
    if nargout > 1
      error(message('MATLAB:TooManyOutputs'));
    end
    varargout = {1};
elseif nargout < 2
    varargout{1} = [1 1];
else
    varargout = num2cell(ones(1, nargout));
end
