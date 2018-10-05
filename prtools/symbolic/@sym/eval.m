function s = eval(x)
%EVAL  Evaluate a symbolic expression.
%   EVAL(S) evaluates the character representation of the
%   symbolic expression S in the caller's workspace.
%
%   See also SUBS.

%   Copyright 1993-2013 The MathWorks, Inc.

if builtin('numel',x) ~= 1,  x = normalizesym(x);  end
s = evalin('caller',vectorize(map2mat(char(x))));

%-------------------------

function r = map2mat(r)
% MAP2MAT MuPAD to MATLAB string conversion.
%   MAP2MAT(r) converts the MuPAD string r containing
%   matrix or array to a valid MATLAB string.
%
%   Examples: map2mat(matrix([[a,b], [c,d]])  returns
%             [a,b;c,d]
%             map2mat(array([[a,b], [c,d]])  returns
%             [a,b;c,d]

% Deblank.
r(strfind(r,' ')) = [];
% Special case of the empty matrix or vector
if regexp(r, '(matrix|array)\((\d+,)*\[\]\)')
  r = '[]';
end
% Remove matrix, vector, or array from the string.
r = strrep(r,'matrix([[','[');
r = strrep(r,'array([[','[');
r = strrep(r,'],[',';');
r = strrep(r,']])',']');
r = strrep(r,'])',']');
