function l = allMuPADNotebooks()
%allMuPADNotebooks All open notebooks.
%   L = allMuPADNotebooks returns a vector with handles to all currently
%   open MuPAD notebooks.
%
%   Example:
%      mupad;
%      mupad('myNotebook.mn');
%      mupad
%      L = allMuPADNotebooks
%
%   See also: mupad, mupadNotebookTitle, evaluateMuPADNotebook, close

%   Copyright 2013 The MathWorks, Inc.

% Create an empty object
l = mupad.empty;

% Get list of uuids
idlist = mupaduimex('GetAllNotebooks');

% Create Notebook handles from uuids and put them to the output vector.
for k = 1:numel(idlist)
    l(k, 1) = mupad('-fromUuid', char(idlist(k)));
end
end