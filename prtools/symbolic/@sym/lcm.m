function c = lcm(a,b,x)
%LCM    Least common multiple.
%   C = LCM(A)   is the symbolic least common multiple of the entries of A.
%   C = LCM(A,B) is the symbolic least common multiple of A and B.
%
%   Example:
%      syms x
%      lcm(x^3-3*x^2+3*x-1, x^2-5*x+4)
%      returns (x - 4)*(x^3 - 3*x^2 + 3*x - 1)
%
%   See also SYM/GCD.

%   Copyright 1993-2014 The MathWorks, Inc.

if nargin == 1
    args = privResolveArgs(a);
    aCell = num2cell(formula(args{1}));
    cSym = feval(symengine, 'lcm', aCell{:});
else
    if nargin == 3
        % check the third argument, but do not use it
        if ~isa(x,'sym') || ~feval(symengine, 'testtype', x, 'Type::Indeterminate')
            error(message('symbolic:sym:gcd:invalidVariable'))
        end
    end
    args = privResolveArgs(sym(a), sym(b));
    cSym = privBinaryOp(args{1}, args{2}, 'symobj::zip', 'lcm');
end

c = privResolveOutput(cSym, args{1});