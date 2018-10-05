function n =  mupadNotebookTitle(nb)
%mupadNotebookTitle Get the window title of a notebook.
%    R = mupadNotebookTitle(NB) returns a cell array containing the window 
%    title of the notebook with the handle NB. If NB is a vector of notebook 
%    handles, then mupadNotebookTitle(NB) returns a cell array of the same 
%    size as NB.     
%
%    Examples:
%      nb = mupad;
%      N = mupadNotebookTitle(nb);
%
%      nb = mupad;
%      titleAsStr = char(mupadNotebookTitle(nb)); 
%      disp(['The current notebook title is: ' titleAsStr]);
%
%    See also: mupad
%

%   Copyright 2013 The MathWorks, Inc.

n=arrayfun(@(h) mupaduimex('GetWindowTitle', h.name), nb, 'UniformOutput', false);
if any(cellfun(@isempty,n))
  error(message('symbolic:mupad:InvalidNotebookHandle'));
end
end

