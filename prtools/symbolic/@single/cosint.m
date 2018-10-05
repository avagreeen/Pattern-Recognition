function z = cosint(x)
%COSINT Cosine integral function.
%  COSINT(x) = eulergamma + log(x) + int((cos(t)-1)/t,t,0,x),
%  where eulergamma denotes the Euler-Mascheroni constant. 
%
%  See also SININT.

%   Copyright 1993-2013 The MathWorks, Inc. 

z = sym.useSymForNumeric(@cosint, x);
