function varargout = unique(varargin) 
%UNIQUE  Symbolic unique function.

%   Copyright 2012 The MathWorks, Inc.

[varargout{1:max(1,nargout)}] = symengine('symUnique', varargin{:});
