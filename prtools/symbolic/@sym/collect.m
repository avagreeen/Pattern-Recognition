function r = collect(s,varargin)
%COLLECT Collect coefficients.
%   COLLECT(S,v) regards each element of the symbolic matrix S as a
%   polynomial in v and rewrites S in terms of the powers of v.
%   COLLECT(S) uses the default variable determined by SYMVAR.
%
%   Examples:
%      collect(x^2*y + y*x - x^2 - 2*x)  returns (y - 1)*x^2 + (y - 2)*x
%
%      f = -1/4*x*exp(-2*x)+3/16*exp(-2*x)
%      collect(f,exp(-2*x))  returns -(x/4 - 3/16)/exp(2*x)
%
%   See also SYM/SIMPLIFY, SYM/FACTOR, SYM/EXPAND, SYM/SYMVAR.

%   Copyright 1993-2011 The MathWorks, Inc.

narginchk(1,2);
args = privResolveArgs(s,varargin{:});
s = args{1};
if nargin == 1
    x = symvar(s,1);
    if isempty(x)
        r = s;
        return;
    end
else 
    x = args{2};
end
rSym = mupadmex('symobj::map',s.s,'symobj::collect',x.s);
r = privResolveOutput(rSym, s);