function syms(varargin)
%SYMS   Short-cut for constructing symbolic variables.
%   SYMS arg1 arg2 ...
%   is short-hand notation for creating symbolic variables
%      arg1 = sym('arg1');
%      arg2 = sym('arg2'); ...
%   or, if the argument has the form f(x1,x2,...), for
%   creating symbolic variables
%      x1 = sym('x1');
%      x2 = sym('x2');
%      ...
%      f = symfun(sym('f(x1,x2,...)'), [x1, x2, ...]);
%   The outputs are created in the current workspace.
%
%   SYMS  ... ASSUMPTION
%   additionally puts an assumption on the variables created.
%   The ASSUMPTION can be 'real', 'rational', 'integer', or 'positive'.
%   SYMS  ... clear
%   clears any assumptions on the variables created, including those
%   made with the ASSUME command.
%
%   Each input argument must begin with a letter and must contain only
%   alphanumeric characters.
%
%   By itself, SYMS lists the symbolic objects in the workspace.
%
%   Example 1:
%      syms x beta real
%   is equivalent to:
%      x = sym('x','real');
%      beta = sym('beta','real');
%
%   To clear the symbolic objects x and beta of 'real' or 'positive' status, type
%      syms x beta clear
%
%   Example 2:
%      syms x(t) a
%   is equivalent to:
%      a = sym('a');
%      t = sym('t');
%      x = symfun(sym('x(t)'), [t]);
%
%   See also SYM, SYMFUN.

%   Deprecated API:
%   The 'unreal' keyword can be used instead of 'clear'.

%   Copyright 1993-2015 The MathWorks, Inc.

if nargin < 1
    w = evalin('caller','whos');
    clsnames = {w.class};
    k = strcmp('sym',clsnames) | strcmp('symfun',clsnames);
    disp(' ')
    disp({w(k).name})
    disp(' ')
    return
end


% the following flags can be used as last argument:
flags = {'real','clear','positive','rational','integer'};

if any(strcmp(varargin{end}, flags))
    control = varargin{end};
    args = varargin(1:end-1);
elseif strcmp(varargin{end}, 'unreal')
    control = 'clear';
    warning(message('symbolic:sym:DeprecateUnreal'));
    args = varargin(1:end-1);
else
    control = '';
    args = varargin;
end


toDefine = sym(zeros(1, 0));
defined = sym(zeros(1, length(args)));
for k=1:length(args)
    x = args{k};
    if isvarname(x) && ~any(strcmp(x, flags))
        xsym = sym(x);
        assignin('caller', x, xsym);
        if ~isempty(control)
            assume(xsym, control);
        end
        defined(k) = xsym;
    elseif isempty(find(x == '(', 1))
        error(message('symbolic:sym:errmsg1'));
    else
        % If a bracket occurs, handle this as a symfun declaration
        [name, vars] = symfun.parseString(x);
        if any(strcmp(name, flags)) 
            error(message('symbolic:sym:errmsg1'));
        end    
        xsym = symfun(x, [vars{:}]);
        % as a side-effect, define all variables that occur as arguments
        toDefine = [toDefine vars{:}]; %#ok<AGROW>.
        defined(k) = sym(name);
        % define the symfun
        assignin('caller', name, xsym);
        % assumptions cannot pertain to symfuns
        if ~isempty(control)
            warning(message('symbolic:sym:VariableExpected', x));
        end 
    end
end

% in the end, define all variables that have occurred only as arguments
for ysym = setdiff(toDefine, defined)
    y = char(ysym);
    if any(strcmp(y, flags))
        error(message('symbolic:sym:errmsg1'));
    end
    assignin('caller', y, ysym);
end
