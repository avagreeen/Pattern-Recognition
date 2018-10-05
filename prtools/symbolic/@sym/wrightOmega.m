function Y = wrightOmega(X)
%WRIGHTOMEGA    Symbolic Wright Omega function.
%   WRIGHTOMEGA(x) computes the Wright omega function of x.
%   WRIGHTOMEGA(A) computes the Wright omega function of each element of A.
%   Reference: Corless, R. M. and D. J. Jeffrey. "The Wright omega Function." 
%   Artificial Intelligence, Automated Reasoning, and Symbolic Computation 
%   (J. Calmet, B. Benhamou, O. Caprotti, L. Henocque, and V. Sorge, eds.). 
%   Berlin: Springer-Verlag, 2002, pp. 76-89.

%   Copyright 2013-2014 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'wrightOmega');
end
