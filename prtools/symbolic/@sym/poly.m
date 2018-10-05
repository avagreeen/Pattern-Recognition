function p = poly(varargin)  %#ok  We do not use p.
%POLY   Symbolic characteristic polynomial.
%   POLY cannot be used to compute the characteristic polynomial 
%   of a SYM matrix; use CHARPOLY instead.
%
%   See also CHARPOLY, MINPOLY, SYM/POLY2SYM, SYM/SYM2POLY, 
%   SYM/JORDAN, SYM/EIG, SOLVE.

%   Copyright 1993-2013 The MathWorks, Inc.

error(message('symbolic:sym:poly:SymPolyWillBeRemoved'));