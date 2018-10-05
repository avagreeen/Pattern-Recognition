function [P,N,R] = poles(f, varargin)
% POLES of a function
%   POLES(f) are the poles of f as a function of x, where x is obtained via
%   symvar(f, 1).
%
%   POLES(f,x)  are the poles of f as a function of x.
%
%   POLES(f,a,b) are the poles of f in the interval (a,b).
%
%   POLES(f,x,a,b) are the poles of f, viewed as a function of x, that lie
%       in the interval (a, b).
%
%   One, two, or three outputs are possible:
%
%   P = POLES(f,x) returns the poles as a symbolic vector.
%
%   [P,N] = POLES(f,x) furthermore assigns to N a symbolic vector of
%   numbers denoting the orders of the poles. An order of NaN indicates 
%   a logarithmic singularity.
%
%   [P,N,R] = POLES(f,x) furthermore assigns to R a symbolic vector of 
%   expressions denoting the residues of f at the poles.
%  
%   If the poles cannot be determined, an empty sym is returned together
%   with a warning. An empty sym without warning indicates that no poles
%   exist.
%
%   Examples:
%       syms a x; poles(a/x)
%       returns 0.
%
%       syms a x; poles(a/x, a)       
%       returns the empty sym, meaning that there are no poles.
%
%       syms x; poles(sin(x)/x/(x-1), -1/2, 1/2)
%       returns the empty sym because the singularity at 0 is removable
%       and the pole at 1 lies outside the given interval
%
%       syms x; [P,N] = poles(1/x/(x-1)^2)
%       assigns the vector of poles [1;0] to P, and the vector of orders
%       [2;1] to N.
%
%       syms a x; [P,N,R] = poles(a/x/(x-1), x)
%       assigns the vector of poles [1;0] to P, and the vector of orders
%       [1;1] to N, and the vector of residues [a;-a] to R.
%
%   See also SOLVE

% Copyright 2012-2014 The MathWorks, Inc.

eng = symengine;

if ~isa(f, 'sym')
    f = sym(f);
end    
if builtin('numel', f) ~= 1
    f = normalizesym(f);  
end

if ~feval(symengine, 'testtype', f, 'Type::Arithmetical')
    error(message('symbolic:sym:poles:FirstArgumentMustBeArithmetical'));
end
    
switch nargin
    case 1
        x = symvar(f, 1);
        if isempty(x), x = sym('x'); end
    case 2
        x = checkvar(varargin{1});
    case 3
        x = symvar(f, 1);
        a = checkbound(varargin{1});
        b = checkbound(varargin{2});
    case 4
        x = checkvar(varargin{1});
        a = checkbound(varargin{2});
        b = checkbound(varargin{3});
end

fs = f.s;
if nargin <= 2
    xs = x.s;
else
    xs = [x.s '=' a.s '..' b.s];
end

if nargout == 0
    outparams = 1;
else
    outparams = nargout;
end

switch outparams
    case 2
        polessym = mupadmex('poles', fs, xs, 'Multiple');
    case 3
        polessym = mupadmex('poles', fs, xs, 'Multiple', 'Residues');
    otherwise
        % no assignment, or nargout == 1
        polessym = mupadmex('poles', fs, xs);
end

tp = feval(eng, 'domtype', polessym);
if ~strcmp(char(tp), 'DOM_SET')
    % we cannot determine the poles in closed form
    warning(message('symbolic:sym:poles:CannotDeterminePoles'));
    P = sym(zeros(0, 1));
    N = sym(zeros(0, 1));
    R = sym(zeros(0, 1));
    return
end

npoles = feval(eng, 'nops', polessym);
if npoles > 1
    % Since polessym is a DOM_SET, we extract the operands because
    % otherwise map(polessym, _index, ...) below would reorder and
    % deduplicate them.
    polessym = feval(eng, 'op', polessym);
end

if nargout < 2
    P = transpose(polessym);
else
    % polessym is a list of pairs or triples
    P = getIndex(eng,polessym,1);
    N = getIndex(eng,polessym,2);
    if nargout > 2
        R = getIndex(eng,polessym,3);
    end
end

function Y = getIndex(eng,obj,n)
Y = transpose(feval(eng, 'map', obj, '_index', num2str(n)));

function V = checkvar(X)
V = sym(X);
if ~sym.isVariable(V)
    error(message('symbolic:sym:poles:InvalidVariable'));
end

function B = checkbound(A)
B = sym(A);
if ~feval(symengine, 'testtype', B, 'Type::Arithmetical')
    error(message('symbolic:sym:poles:InvalidBound'));
end
