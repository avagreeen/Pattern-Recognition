function P = beta(x,y)
%BETA(X,Y) Beta function.
%   W = BETA(X,Y) is defined as GAMMA(X)*GAMMA(Y)/GAMMA(X+Y), where GAMMA
%   is the GAMMA function.
%
%   Reference:
%       [1] M. Zelen and N. C. Severo. in Milton Abramowitz and Irene A.
%       Stegun, eds. Handbook of Mathematical Functions with Formulas,
%       Graphs, and Mathematical Tables. New York: Dover, 1972.

%   Copyright 2013 The MathWorks, Inc.

P = privBinaryOp(x, y, 'symobj::vectorizeSpecfunc', 'beta', 'infinity');
end
