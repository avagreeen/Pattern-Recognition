function pretty(X)
%PRETTY Pretty print a symbolic expression.
%   PRETTY(S) prints the symbolic expression S in a format that 
%   resembles type-set mathematics.
%
%   See also SYM/SUBEXPR, SYM/LATEX, SYM/CCODE.

%   Copyright 1993-2013 The MathWorks, Inc.

% get the correct number of digits to display for symfuns:
numbers = regexp(X(1).s, '^_symans_(\d+)', 'tokens');
if ~isempty(numbers)
  oldDigits = digits(numbers{1}{1});
  resetDigits = onCleanup(@() digits(oldDigits));
end

if builtin('numel',X) ~= 1,  X = normalizesym(X);  end
mupadmex('on',7); % enable pretty-printing
cleanup = onCleanup(@() mupadmex('off',7)); % disable pretty-printing
manualWidth = isappdata(0,'SymObjectPrettyWidth');
if manualWidth
    width = getappdata(0,'SymObjectPrettyWidth');
else
    cw = matlab.desktop.commandwindow.size;
    width = max(cw(1),40);
end
mupadmex('symobj::pretty',X.s,int2str(width));
