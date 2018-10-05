function setVar(nb,var,y)
%setVar Assign variable in a notebook.
%    setVar(NB,VAR,Y) assigns the sym object Y to variable VAR in the
%    MuPAD notebook NB. VAR must be a valid variable name (see ISVARNAME).
%
%    Example:
%      syms x
%      y = sin(x);
%      setVar(nb,'f',x^2+1)
%
%    See also: mupad, getVar, sym, isvarname

%   Copyright 2011-2015 The MathWorks, Inc.

narginchk(3,3);

if ~isa(nb, 'mupad')
    error(message('symbolic:mupad:MuPADObject'));
end
if isempty(nb)
    error(message('symbolic:mupad:InvalidNotebookHandle')); 
end
if isscalar(nb) && isempty(mupaduimex('GetWindowTitle', nb.name))
    error(message('symbolic:mupad:InvalidNotebookHandle'));  
end
if ~isvarname(var)
    error(message('symbolic:mupad:setVar:InvalidName'));
end

if ~isa(y,'sym')
    error(message('symbolic:mupad:setVar:InvalidValue'));
end
cc = charcmd(y);
if feval(symengine, 'has', cc, var)
    error(message('symbolic:mupad:setVar:RecursiveAssignment'));
end

var64 = feval(symengine,'symobj::outputBase64', cc);
mucmd = sprintf('%s := symobj::inputBase64("%s"):', var, char(var64));
failedNbs = 0;
for k = 1:numel(nb)
    nbk = nb(k);
    if isempty(mupaduimex('GetWindowTitle', nbk.name))
        failedNbs = failedNbs + 1;
    else
        mupaduimex('EvaluateCommand', nbk.name, mucmd);
    end
end
if failedNbs > 0
    if failedNbs == k
        error(message('symbolic:mupad:AllInvalidNotebookHandles'));
    else
        warning(message('symbolic:mupad:OneInvalidNotebookHandle'));
    end
end

end
