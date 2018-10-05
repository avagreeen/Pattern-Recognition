function [Q,R] = quorem(A,B,x)
%QUOREM Symbolic matrix element-wise quotient and remainder.
%   [Q,R] = QUOREM(A,B,var) for symbolic matrices A and B with integer
%   or  polynomial elements divides A by B (element-wise) and returns
%   the quotient Q and remainder R of the division,
%   such that A = Q.*B + R, and the degree of R in the variable var
%   is smaller than that of B, element-wise.
%   This syntax regards A and B as polynomials in the variable var.
%
%   [Q,R] = QUOREM(A,B) uses the variable determined by symvar(A,1).
%   If symvar(A,1) returns an empty symbolic object sym([]),
%   then QUOREM uses the variable determined by symvar(B,1).
%   If both symvar(A,1) and symvar(B,1) are empty, A and B must have
%   integer entries and QUOREM(A,B) returns symbolic matrices Q and R
%   with integer entries such that A = Q.*B + R, and each element of R
%   is smaller in absolute value than the matching one of B.
%
%   Example:
%      syms x
%      p = x^3-2*x+5
%      [q,r] = quorem(x^5,p)
%         q = x^2 + 2
%         r = 4*x - 5*x^2 - 10
%      [q,r] = quorem(10^5,subs(p,'10'))
%         q = 101
%         r = 515
%
%   See also SYM/MOD, SYM/RDIVIDE, SYM/LDIVIDE.

%   Copyright 1993-2014 The MathWorks, Inc.

if nargin < 2
  error(message('symbolic:sym:minrhs'));
end

args = privResolveArgs(sym(A), sym(B));

A = formula(args{1});
B = formula(args{2});

if ((ndims(A) ~= ndims(B)) || any(size(A) ~= size(B))) && ...
  (~isscalar(A) && ~isscalar(B))
  error(message('symbolic:sym:dimagree'));
end

if nargin < 3
    x = symvar(args{1},1);
    if isempty(x)
        x = symvar(args{2},1);
    end    
elseif ~sym.isVariable(x)
    error(message('symbolic:sym:SymVariableExpected3'))
end

if isempty(x)
    [Qsym,Rsym] = mupadmexnout('symobj::quoremInt',args{:});
else
    [Qsym,Rsym] = mupadmexnout('symobj::quoremPoly',args{:},x);
end
Q = privResolveOutput(Qsym, args{1});
R = privResolveOutput(Rsym, args{1});
