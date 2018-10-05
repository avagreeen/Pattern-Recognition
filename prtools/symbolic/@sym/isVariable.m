function B = isVariable(x)
%  isVariable(x)
% 
%  Static hidden sym method to check if the argument is a symbolic variable

%   Copyright 2015 The MathWorks, Inc.
B = isa(x, 'sym') && ~isa(x, 'symfun') && feval(symengine, 'testtype', x, 'Type::Indeterminate');
end
