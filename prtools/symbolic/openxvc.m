function out = openxvc(file)
%OPENXVC Open MuPAD graphics file
%   OPENXVC(FILE) opens the MuPAD graphics file named FILE.
%
%   See also OPEN, MUPAD

%  Copyright 2009-2012 The MathWorks, Inc

out = [];
mupaduimex('OpenGraphics', file);
