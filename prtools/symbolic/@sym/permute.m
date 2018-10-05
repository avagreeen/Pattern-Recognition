function B = permute(A, order)
%PERMUTE Permute symbolic array dimensions.
%   B = PERMUTE(A,ORDER) rearranges the dimensions of A so that they
%   are in the order specified by the vector ORDER.  The array produced
%   has the same values as A but the order of the subscripts needed to
%   access any particular element are rearranged as specified by ORDER.
%   For an N-D array A, numel(ORDER)>=ndims(A). All the elements of
%   ORDER must be unique.
%
%   PERMUTE and IPERMUTE are a generalization of transpose (.')
%   for N-D arrays.
%
%   Example:
%     a = sym(ones(1,2,3,4));
%     size(permute(a,[3 2 1 4])) % now it's 3-by-2-by-1-by-4.
%
%   See also SYM/TRANSPOSE.

%   Copyright 2013 The MathWorks, Inc.

narginchk(2,2);
if ~isnumeric(order) && ~isa(order,'sym')
    error(message('symbolic:permute:badIndexType'));
end
if ~isa(A,'sym')
  B = permute(A,double(order));
  return;
end
B = privBinaryOp(A, order, 'symobj::permute');
end
