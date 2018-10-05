function [f, x, a, b] = parseFunctionVariableBounds(f, x, a, b)
%parseFunctionVariableBounds Private helper method for argument parsing
% This private helper function assists in parsing inputs to a function
% with calling syntax
% S(f)
% S(f, x)
% S(f, [a b])
% S(f, a, b)
% S(f, x, [a b])
% S(f, x, a, b)
% where x defaults to symvar(f, 1).
% Such functions S are, for example, symsum and symprod

f = sym(f);
switch nargin
    case 1
        x = symv(f);
        a = [];
        b = [];
    case 2
        [a, b] = rangeVector(sym(x));
        if ~isempty(a)
            x = symv(f);
        end        
    case 3
        a = sym(a);
        [tmp, b] = rangeVector(a);
        if isempty(tmp)
            b = a;
            a = sym(x);
            x = symv(f);   
        else    
            a = tmp;
        end
    case 4
        a = sym(a);
        b = sym(b);
end


function X = symv(f)
X = symvar(f, 1);
if isempty(X)
    X = sym('x');
end    

function [a, b] = rangeVector(x)
xf = formula(x);
if isvector(xf) && numel(xf) == 2 
    a = privsubsref(xf,1);
    b = privsubsref(xf,2);
else 
    a = [];
    b = [];
end    


