function out = openmu(file)
%OPENMU Open MuPAD program file
%   OPENMU(FILE) opens the MuPAD program file named FILE.
%
%   See also OPEN, MUPAD

%  Copyright 2008-2012 The MathWorks, Inc.

out = [];
edit(file);
