function y = cat(dim, varargin)
%CAT Concatenation for sym arrays.
%   C = CAT(DIM, A, B, ...) concatenates the sym arrays A,
%   B, etc. along the dimension DIM.
%
%   See also HORZCAT, VERTCAT.

%   Copyright 2010-2014 The MathWorks, Inc.


if nargin > 1
    if isa(dim, 'sym')
        y = cat(double(dim), varargin{:});
        return
    end    
    args = privResolveArgs(varargin{:});
else
    args = {};
end
dim = double(dim);

if ~isscalar(dim) || fix(dim)~=dim || dim <= 0 || ~isfinite(dim)
    error(message('symbolic:catenate:invalidDimension'));
end
% catenate the arguments in args (if any) along dim
if isempty(args)
    y = sym([]);
elseif length(args) == 1
    y = args{1};
else
    ySym = catMany(dim, args);
    y = privResolveOutput(ySym, args{1});
end

function y = catMany(dim,arrays)
% catenate multiple arrays
n = length(arrays);
sz = cellfun(@size,arrays,'UniformOutput',false);
[resz, ranges] = checkDimensions(sz,dim);
resNDims = length(resz);
subs = cell(1,resNDims);
subs(:) = {':'};
y = sym(zeros(resz));
y = reshape(y,resz);
for k=1:n
    if prod(sz{k})>0
        subs(dim) = {ranges(k):ranges(k+1)-1};
        y = privsubsasgn(y,arrays{k},subs{:});
    end
end

function [resz,ranges] = checkDimensions(sz,dim)
% validate and compute the output dimensions. Also compute the indexing ranges for each slice.
n = length(sz);
bigdim = max(cellfun(@length,sz));
allsz = ones(n,max(dim,bigdim));
pureempty = findPureEmpty(sz,n);
if all(pureempty)
    allsz(:,:) = 0;
    if dim>2
        allsz(:,dim) = 1;
    end
else
    allsz = mixedDimensions(sz,n,allsz,pureempty);
end
resz = max(allsz);
resz(dim) = sum(allsz(:,dim));
ranges = cumsum([1;allsz(:,dim)]);
% now check that all the non-dim sizes match (except pure empties)
allsz(pureempty,:) = [];
allsz(:,dim) = resz(dim);
ok = bsxfun(@eq,allsz,resz);
if ~all(ok(:))
    error(message('symbolic:catenate:dimensionMismatch'));
end
resz = stripTrailingOnes(resz);

function pureempty = findPureEmpty(sz,n)
% return true if all the sizes are 0-by-0
pureempty = false(1,n);
for k=1:n
    szk = sz{k};
    pureempty(k) = all(szk==0) && length(szk)==2;
end

function allsz = mixedDimensions(sz,n,allsz,pureempty)
% compute the resulting sizes if the input sizes are mixed
for k=1:n
    if pureempty(k)
        allsz(k,:) = 0;
    else
        szk = sz{k};
        allsz(k,1:length(szk)) = szk;
    end
end

function resz = stripTrailingOnes(resz)
% remove any trailing single dimensions
n = find(fliplr(resz)~=1,1);
if length(resz)>2 && n > 1
    n = max(3,length(resz)-n+2);
    resz(n:end) = [];
end
