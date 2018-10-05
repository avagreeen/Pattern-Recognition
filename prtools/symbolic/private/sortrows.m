function [y,ndx] = sortrows(x)
%SORTROWS Sort symbolic matrix rows

%   Copyright 2012 The MathWorks, Inc.

[y,ndx] = mupadmexnout('symobj::sort',x,'"Rows"','TRUE','TRUE');
ndx = double(ndx);
