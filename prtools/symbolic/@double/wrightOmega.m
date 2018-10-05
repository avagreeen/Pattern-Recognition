function W = wrightOmega(X)
%WRIGHTOMEGA Wright omega function.
%   W = WRIGHTOMEGA(X) is a solution of the equation Y + log(Y) = X.
%
%   Reference:
%       [1] Corless, R. M. and Jeffrey, D. J. "The Wright omega Function."
%       In Artificial Intelligence, Automated Reasoning, and Symbolic
%       Computation (Ed. J. Calmet, B. Benhamou, O. Caprotti, L. Henocque
%       and V. Sorge). Berlin: Springer-Verlag, pp. 76-89, 2002.

%   Copyright 2012 The MathWorks, Inc.
W = sym.useSymForNumeric(@wrightOmega, X);
