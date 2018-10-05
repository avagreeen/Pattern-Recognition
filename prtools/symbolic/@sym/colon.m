function c = colon(a,d,b)
%COLON  Symbolic colon operator.
%   COLON(A,B) overloads symbolic A:B.
%   COLON(A,D,B) overloads symbolic A:D:B.
%
%   Example:
%       0:sym(1/3):1 is [  0, 1/3, 2/3,  1]

%   Copyright 1993-2014 The MathWorks, Inc.

narginchk(2,3);

if nargin == 2
  b = d;
  d = 1;
end

args = privResolveArgs(a,b,d);
a = formula(sym(args{1}));
b = formula(sym(args{2}));
d = formula(sym(args{3}));
if numel(a) > 1
  a = privsubsref(a,1);
end
if numel(d) > 1
  d = privsubsref(d,1);
end
if isempty(a) || isempty(b) || isempty(d) || d == 0
  c = sym(zeros(1,0));
else
  if numel(b) > 1
    b = privsubsref(b,1);
  end
  try
    n = double((b-a)/d);
  catch me
    if strcmp(me.identifier,'symbolic:double:cantconvert')
      error(message('symbolic:colon:unknownStep', char(a), char(b), char(d)));
    else
      rethrow(me);
    end
  end
  c = a + (0:n)*d;
end

if strcmp(mupadmex(['stdlib::hasfloat([' a.s ',' b.s ',' d.s '])'], 0), 'TRUE')
  c = vpa(c);
end

c = privResolveOutput(c, args{1});
