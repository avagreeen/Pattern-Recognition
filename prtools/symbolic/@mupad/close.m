function close(nb, varargin) 
%CLOSE Close a notebook    
%    close(NB) closes notebook NB.
%
%    close(NB, 'force') closes notebook NB without asking for saving
%    the changes. All modifications will be lost.
%
%    See also: mupad

%    Copyright 2013-2014 The MathWorks, Inc.

p = inputParser;
p.addRequired('nb');
p.addOptional('force', '', @(x) true);
p.parse(nb, varargin{:});

forceClose = ~isempty(p.Results.force);
if forceClose
    validatestring(p.Results.force, {'force'});
end

nb(~isvalid(nb)) = [];
for k = 1:numel(nb)
    nbk = nb(k);
    if ~isempty(nbk.name)
        mupaduimex('CloseNotebook', nbk.name, forceClose);
    end
end

end
