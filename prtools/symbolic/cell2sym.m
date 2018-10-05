function S = cell2sym(C, flag)
%CELL2SYM Convert cell array to sym array
%   S = CELL2SYM(C) converts the cell array C into a sym array. 
%   The contents of C must be convertible to sym objects. 
%
%	Example:
%	   C = {'x' [2 3 4]; ['y'; sym(9)] [6 7 8; 10 11 12]};
%	   S = cell2sym(C)
%
%	See also CELL2MAT, MAT2CELL, NUM2CELL, SYM2CELL.

% Copyright 2015 The MathWorks, Inc.

narginchk(1, 2);
if ~iscell(C)
    error(message('symbolic:sym:InputMustBeCell'))
end    
if nargin == 2
    if ~ischar(flag) || ~any(strcmpi(flag, {'f', 'r', 'e', 'd'}))
        % invalid flag. Use the same error message as in sym
        error(message('symbolic:sym:sym:errmsg6'));
    end
    conv = @(x) convertWithFlag(x, flag);
else
    conv = @sym;
end

Csym = cellfun(conv, C, 'UniformOutput', false);
% Cell arrays of symfuns become sym
Csym = cellfun(@formula, Csym, 'UniformOutput', false);

if all(cellfun(@isscalar, Csym(:)))
    % simple case
    S = reshape(sym([Csym{:}]), size(C));
else
    S = symcell2mat(Csym);
end


function S = convertWithFlag(x, flag)
% convert numbers using the flag, ignore flag on all other inputs
if isnumeric(x) || islogical(x)
    S = sym(x, flag);
else
    S = sym(x);
end    


function m = symcell2mat(c)
% This is a copy of the main loop of cell2mat, to achieve consistent
% behavior.
csize = size(c);
% Construct the matrix by concatenating each dimension of the cell array into
%   a temporary cell array, CT
% The exterior loop iterates one time less than the number of dimensions,
%   and the final dimension (dimension 1) concatenation occurs after the loops

% Loop through the cell array dimensions in reverse order to perform the
%   sequential concatenations
for cdim=(length(csize)-1):-1:1
    % Pre-calculated outside the next loop for efficiency
    ct = cell([csize(1:cdim) 1]);
    cts = size(ct);
    ctsl = length(cts);
    mref = {};

    % Concatenate the dimension, (CDIM+1), at each element in the temporary cell
    %   array, CT
    for mind=1:prod(cts)
        [mref{1:ctsl}] = ind2sub(cts,mind);
        % Treat a size [N 1] array as size [N], since this is how the indices
        %   are found to calculate CT
        if ctsl==2 && cts(2)==1
            mref = mref(1);
        end
        % Perform the concatenation along the (CDIM+1) dimension
        ct{mref{:}} = cat(cdim+1,c{mref{:},:});
    end
    % Replace M with the new temporarily concatenated cell array, CT
    c = ct;
end

% Finally, concatenate the final rows of cells into a matrix
m = cat(1,c{:});
