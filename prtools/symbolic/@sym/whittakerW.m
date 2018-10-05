function y = whittakerW(a,b,x)
%whittakerW    Symbolic Whittaker W function.

%   Copyright 2013 The MathWorks, Inc.

y = privTrinaryOp(a, b, x, 'symobj::vectorizeSpecfunc', 'whittakerW', 'infinity');
end
