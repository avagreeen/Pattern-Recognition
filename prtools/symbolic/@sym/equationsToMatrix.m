function varargout = equationsToMatrix(varargin)
%equationsToMatrix  Convert linear equations to matrix notation.
%   [A,b] = equationsToMatrix([eq1,eq2,eq3,...],[x1,x2,...,xn]) converts 
%   the equations eq1,eq2,eq3,... to matrix notation. Equations need to be
%   linear in the variables specified as second argument. eq1,eq2,eq3,...
%   can be SYM equations or simply SYM objects. In case eq1,eq2,eq3,... 
%   are generic SYM objects, they will be interpreted as left sides 
%   of equations, whose right sides are equal to 0. The equations just
%   need to be linear in the given variables, it does not play a role how 
%   they are ordered or on which side of the equations the unknowns show up. 
%
%   [A,b] = equationsToMatrix([eq1,eq2,eq3,...]) converts the equations 
%   [eq1,eq2,eq3,...] to matrix notation. Equations need to be linear in
%   all variables of the equations. The system is interpreted as a linear 
%   system of equations in the variables symvar([eq1,eq2,eq3,...]).
%
%   [A,b] = equationsToMatrix(eq1,eq2,eq3,...,x1,x2,...,xn) does the same 
%   as equationsToMatrix([eq1,eq2,eq3,...],[x1,x2,...,xn]). 
%  
%   [A,b] = equationsToMatrix(eq1,eq2,eq3,...) does the same as 
%   equationsToMatrix([eq1,eq2,eq3,...]). 
%
%   If you do not assign the output to variables A and b or just assign the 
%   output to a single variable, only the matrix A will be returned.  
%
%   Examples: 
%
%   syms x y z
%   eq1 = x + y + z
%   eq2 = x - 2*y - 5*z == 0
%   eq3 = x - z == 1
%  
%   [A,B] = equationsToMatrix([eq1,eq2,eq3],[x,y,z])
%   A = equationsToMatrix([eq1,eq2,eq3],[x,y,z])
%   [A,B] = equationsToMatrix(eq1,eq2,eq3,x,y,z)
%   A = equationsToMatrix(eq1,eq2,eq3,x,y,z)
%   [A,B] = equationsToMatrix([eq1,eq2,eq3])
%   A = equationsToMatrix([eq1,eq2,eq3])
%   [A,B] = equationsToMatrix(eq1,eq2,eq3)
%   A = equationsToMatrix(eq1,eq2,eq3)
%
%   See also LINSOLVE, MLDIVIDE, SYM/LINSOLVE, SYM/MLDIVIDE, SOLVE, DSOLVE

%   Copyright 2012-2014 The MathWorks, Inc.

eng = symengine;
argv = cellfun(@sym, varargin, 'UniformOutput', false);

if isempty(argv{end})
    % allow the edge case that the variables may be empty,
    % for compatibility reasons
    vars = argv{end};
    eqns = [argv{1:end-1}];
else
    [eqns,vars] = sym.getEqnsVars(argv{:});
    if isempty(vars)
        vars = symvar(eqns);
    end    
end
    
T = eng.feval('symobj::equationsToMatrix',eqns,vars);
A = eng.feval('_index',T,'"CoeffMatrix"');
b = eng.feval('_index',T,'"RightSide"');

if nargout == 2
     varargout{1} = A;
     varargout{2} = b;
else
     varargout{1} = A;
end

end