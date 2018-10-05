function A=repmat(B,varargin)
%REPMAT Replicate and tile an array.
%   See HELP REPMAT for details.

%   Copyright 2014 The MathWorks, Inc.
args = cellfun(@double,varargin,'UniformOutput',false);
if isa(B,'symfun')
  A = symfun(repmat(formula(B),args{:}),argnames(B));
else
  % just ignore that some numbers have been given as symfuns
  A = repmat(B,args{:});
end
