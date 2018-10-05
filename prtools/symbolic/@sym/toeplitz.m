function t = toeplitz(c,varargin)
%TOEPLITZ Toeplitz matrix.
%   TOEPLITZ(C,R) is a non-symmetric Toeplitz matrix having C as its
%   first column and R as its first row.   
%
%   TOEPLITZ(R) is a symmetric Toeplitz matrix for real R.
%   For a complex vector R with a real first element, T = toeplitz(r) 
%   returns the Hermitian Toeplitz matrix formed from R. When the 
%   first element of R is not real, the resulting matrix is Hermitian 
%   off the main diagonal, i.e., T_{i,j} = conj(T_{j,i}) for i ~= j.

%   Copyright 2012 The MathWorks, Inc. 

if nargin > 2 
    error(message('symbolic:sym:toeplitz:OneOrTwoArgumentsAreExpected'));
end

if ischar(c) 
    error(message('symbolic:sym:toeplitz:FirstArgumentMustBeAVector'));
elseif nargin > 1 && ischar(varargin{1})
    error(message('symbolic:sym:toeplitz:SecondArgumentMustBeAVector'));
end

p = inputParser;

p.addRequired('c'); 
p.addOptional('r',sym([])); 
p.parse(c,varargin{:});

c = p.Results.c;
r = p.Results.r;

args = privResolveArgs(c,r);
csym = formula(args{1});
rsym = formula(args{2});

if ~isempty(csym)
    if size(csym,1)~=1 && size(csym,2)~=1
        error(message('symbolic:sym:toeplitz:FirstArgumentMustBeAVector'));
    end
    if ~isempty(rsym)
        if size(rsym,1)~=1 && size(rsym,2)~=1
            error(message('symbolic:sym:toeplitz:SecondArgumentMustBeAVector'));
        end
        t = mupadmex('symobj::toeplitz',rsym.s,csym.s);
    else
        if nargin == 1 
            t = mupadmex('symobj::toeplitz',csym.s);
        else
            t = sym([]);
        end
    end
else
    t = sym([]);
end

t = privResolveOutput(t, args{1});
