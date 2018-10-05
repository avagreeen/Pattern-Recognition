function [g,c,d] = gcd(A, B, x)
%GCD    Greatest common divisor.
%   G = GCD(A) is the symbolic greatest common divisor of all entries of A.
%   G = GCD(A,B) is the symbolic greatest common divisor of A and B.
%   [G,C,D] = GCD(A,B,X) also returns C and D  so that G = A*C + B*D,
%   and X does not appear in the denominator of C and D. 
%   If X is missing, it is chosen using SYMVAR.
%
%   Example:
%      syms x
%      gcd(x^3-3*x^2+3*x-1,x^2-5*x+4) 
%      returns x-1
%
%   See also SYM/LCM.

%   Copyright 1993-2014 The MathWorks, Inc.

A = sym(A);

switch nargin
    case 1
        % gcd of a vector of arguments
        nargoutchk(0, 1);
        args = privResolveArgs(A);
        a = num2cell(formula(args{1}));
        gSym = feval(symengine, 'gcd', a{:});
        g = privResolveOutput(gSym, args{1});
        return
    case 2
        args = privResolveArgs(A, B); 
        if nargout >= 2
            x = symvar([symvar(args{1}), symvar(args{2})], 1);
            if isempty(x)
                % just need a dummy variable
                x = sym('x');
            end    
        end
    case 3
        args = privResolveArgs(A, B); 
        if ~sym.isVariable(x)
            error(message('symbolic:sym:gcd:invalidVariable'))
        end
end         


if nargout <= 1
    %  gcd of two arguments. A possible third argument is just ignored
    gSym = privBinaryOp(args{1}, args{2}, 'symobj::zip', 'gcd');
    g = privResolveOutput(gSym, args{1});
    return
end    
    

% extended gcd 
result = feval(symengine, 'symobj::zip', args{1}, args{2}, 'symobj::gcdex', x);

if numel(formula(args{1})) == 1 && numel(formula(args{2})) == 1
    % simple case
    res = num2cell(result);
else
    res = cell(1, 3);
    for i=1:3
        res{i} = feval(symengine, 'symobj::map', result, 'op', i);
    end
end
    
g = privResolveOutput(res{1}, args{1});
c = privResolveOutput(res{2}, args{1});
d = privResolveOutput(res{3}, args{1});
