function r = evaluateMuPADNotebook(nb, varargin)
%evaluateMuPADNotebook Evaluate a MuPAD Notebook.
%   R = evaluateMuPADNotebook(NB) evaluates the Notebook NB and returns 
%   true if it evaluates successfully. If NB is a vector of Notebooks a
%   vector of logicals is returned.
%   
%   R = evaluateMuPADNotebook(NB, 'IgnoreErrors', VAL) controls if the
%   evaluation stops in case of a MuPAD error. If VAL is TRUE the
%   evaluation continues even if one or more MuPAD errors occur, otherwise 
%   it stops at the first MuPAD error. The default is FALSE.
%
%    Example:
%      nb = mupad;
%      R = evaluateMuPADNotebook(nb);
%      R = evaluateMuPADNotebook(nb, 'IgnoreErrors', true);
%
%    See also: mupad, setVar, getVar, allMuPADNotebooks, close
%

%   Copyright 2013-2014 The MathWorks, Inc.


p = inputParser;
p.addRequired('nb');
p.addParameter('IgnoreErrors', false, @(x) isequal(x,true) || isequal(x,false));
p.parse(nb, varargin{:});

r = true(size(nb));

for n = 1:numel(nb)
    % Get the title of the notebook. We need it later anyway. Error if
    % there is no title (means, the Notebook is gone)
    nbtitle = mupaduimex('GetWindowTitle', nb(n).name);
    if isempty(nbtitle)
        error(message('symbolic:mupad:InvalidNotebookHandle'));
    end
    
    % Get list of input regions
    inputlist = mupaduimex('GetInputIDs', nb(n).name);

    % Evaluate regions
    for i = 1:numel(inputlist)
        result = mupaduimex('EvaluateInputWithID', nb(n).name, inputlist(i));
        if result < 1
            r(n) = false; 
        end
        if result == -2
            error(message('symbolic:mupad:evaluateMuPADNotebook:UserCanceled', nbtitle));
        end
        if result == -1 && ~p.Results.IgnoreErrors
            error(message('symbolic:mupad:evaluateMuPADNotebook:MuPADError', num2str(i), nbtitle));
        end
    end

end

end
