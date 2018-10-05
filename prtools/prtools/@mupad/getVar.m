function y = getVar(nb,var)
%getVar Get a variable from a notebook.
%    Y = getVar(NB,VAR) gets the variable VAR from notebook NB
%    and returns the result as a sym object Y.
%
%    Example:
%      f = getVar(nb,'f')
%
%    See also: mupad, setVar, sym

%   Copyright 2011-2013 The MathWorks, Inc.

narginchk(2,2);
if ~isa(nb, 'mupad')
    error(message('symbolic:mupad:MuPADObject'));
end
if ~isscalar(nb)
    if isempty(nb)
        error(message('symbolic:mupad:InvalidNotebookHandle'));
    end
    error(message('symbolic:mupad:getVar:MultiNotebook'));
end
if ~ischar(var) || ~isvarname(var)
    error(message('symbolic:mupad:getVar:VarName'));
end
if (isempty(mupaduimex('GetWindowTitle', nb.name)))
    error(message('symbolic:mupad:InvalidNotebookHandle'));
end

mucmd = sprintf('symobj::outputBase64(%s);', char(var));

myVar64 = mupaduimex('GetVar', nb.name, mucmd);
y = feval(symengine,'symobj::inputBase64',myVar64);

end
