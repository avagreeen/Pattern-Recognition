function A=repelem(B,varargin)
%REPELEM Replicate and tile an array.
%   See HELP REPELEM for details.

%   Copyright 2015 The MathWorks, Inc.
args = cellfun(@double,varargin,'UniformOutput',false);
if isa(B,'symfun')
  A = symfun(repelem(formula(B),args{:}),argnames(B));
else
  % just ignore that some numbers have been given as symfuns
  A = repelem(B,args{:});
end
