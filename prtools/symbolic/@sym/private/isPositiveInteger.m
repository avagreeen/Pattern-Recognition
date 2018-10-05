function B = isPositiveInteger(x)
if ~isa(x, 'sym') && ~isnumeric(x)
   B = false;
   return
end   
s = formula(sym(x));
B = isscalar(s) && feval(symengine, 'testtype', s, 'Type::PosInt');