function y = whittakerM(a,b,x)
%whittakerM    Symbolic Whittaker M function.

%   Copyright 2013 The MathWorks, Inc.

y = privTrinaryOp(a, b, x, 'symobj::vectorizeSpecfunc', 'whittakerM', 'infinity');
end