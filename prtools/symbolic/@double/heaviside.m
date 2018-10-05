function Y = heaviside(X)
%HEAVISIDE    Step function.
%    HEAVISIDE(X) is 0 for X < 0 and 1 for X > 0.
%    The value HEAVISIDE(0) is 0.5 by default. It
%    can be changed to any value v by the call 
%    sympref('HeavisideAtOrigin', v).
%
%    HEAVISIDE(X) is not a function in the strict sense.
%    See also DIRAC.

%   Copyright 1993-2015 The MathWorks, Inc.

Y = zeros(size(X),'like',X);
Y(X > 0) = 1;
if any(X(:)==0)
  try 
    h0 = double(sympref('HeavisideAtOrigin'));
  catch 
    error(message('symbolic:sympref:SymbolicHeavisideAtOrigin'));
  end
  Y(X==0) = h0;
end
Y(isnan(X) | imag(X) ~= 0 ) = NaN;
