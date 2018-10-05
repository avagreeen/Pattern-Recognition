function varargout = ismember(A,B,varargin) 
%ISMEMBER  Symbolic ismember function.

%   Copyright 2012 The MathWorks, Inc.

narginchk(2,4);

if ~isa(A,'sym'),  A = sym(A); end
if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
if ~isa(B,'sym'),  B = sym(B); end
if builtin('numel',B) ~= 1,  B = normalizesym(B);  end

[varargout{1:max(1,nargout)}] = symengine('symIsMember', A, B, varargin{:});
