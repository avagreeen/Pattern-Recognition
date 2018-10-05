function [V, Y] = odeToVectorField(varargin)
    %odeToVectorField Converting scalar differential equations to coupled 
    %                 first order systems (vector fields). 
    %
    %   V = odeToVectorField('eqn1','eqn2', ...) accepts symbolic equations 
    %   representing ordinary differential equations given in terms of  
    %   strings. The differential equations must be linear in the highest  
    %   derivatives of the unknown functions involved.
    %
    %   The output 'V' is a SYM object containing the components of the  
    %   coupled first order system associated with 'eqn1','eqn2', ... 
    %   The output 'V' can be used as input for matlabFunction to generate  
    %   a MATLAB function. Such a function then can be used to define input  
    %   for a numerical ODE solver in MATLAB. 
    %
    %   By default, the independent variable is 't'. The independent 
    %   variable may be changed from 't' to some other symbolic variable by 
    %   including that variable as the last input argument.
    %
    %   The letter 'D' denotes differentiation with respect to the 
    %   independent variable, i.e. usually d/dt.  A "D" followed by a digit 
    %   denotes repeated differentiation; e.g., D2 is d^2/dt^2.  
    %   Any characters immediately following these differentiation 
    %   operators are taken to be the dependent variables; 
    %   e.g., D3y denotes the third derivative of y(t). Note that the names 
    %   of symbolic variables should not contain the letter "D".
    % 
    %   E.g. the input 'D2x = -3*t' represents the differential equation 
    % 
    %                          d^2/dt^2 x(t) = -3*t.
    % 
    %   V = odeToVectorField('eqn1','eqn2', ...) returns a SYM object   
    %   containing the components of the coupled first order system 
    %   associated with 'eqn1','eqn2', ...
    %
    %   [V,Y] = odeToVectorField('eqn1','eqn2', ...) additionally returns 
    %   the SYM object 'Y' listing the substitutions that have been made 
    %   for converting the input equations 'eqn1','eqn2', ... into the 
    %   components of 'V'.  
    %
    %   Note that the result for 'V' can directly be used as input for 
    %   matlabFunction in order to create a MATLAB function that can passed
    %   to one of MATLAB's numerical ODE solvers. See the examples below. 
    % 
    %   Example 1:
    %
    %      V = odeToVectorField('D2x = -3*t') returns
    %
    %        V =
    %   
    %         Y[2]
    %         -3*t
    %
    %      [V,Y] = odeToVectorField('D2x + t*Dx + x = -3*t')
    %
    %        V =
    %
    %                          Y[2]
    %         - 3*t - t*Y[2] - Y[1]
    % 
    % 
    %        Y = 
    % 
    %          x
    %         Dx
    %
    %      The result contained in 'V' can be used as input for 
    %      MATLABFUNCTION:
    %
    %      M = matlabFunction(V,'vars', {'t', 'Y'})
    %
    %        M = @(t,Y)[Y(2),t.*-3.0-t.*Y(2)-Y(1)]
    %
    %   Example 2:
    %      You can also apply odeToVectorField on systems of scalar  
    %      differential equations: 
    %
    %      [V,Y] = odeToVectorField('D2f = f + g','Dg = -f + g')
    % 
    %        V =
    %  
    %         Y[1] - Y[2]
    %                Y[3]
    %         Y[1] + Y[2]
    %   
    %        Y =
    %  
    %          g
    %          f 
    %         Df
    %
    %      We compute the state space representation for y''=(1-y^2)*y'-y       
    %
    %      [V,Y] = odeToVectorField('D2y = (1-y^2)*Dy - y')
    % 
    %        V =
    %
    %                               Y[2]
    %         - (Y[1]^2 - 1)*Y[2] - Y[1]
    %  
    %        Y =
    % 
    %          y
    %         Dy
    %
    %      use it as input for MATLABFUNCTION 
    %
    %      M = matlabFunction(V,'vars', {'t', 'Y'})
    %
    %        M = @(t,Y)[Y(2);-(Y(1).^2-1.0).*Y(2)-Y(1)]
    %
    %      and then use MATLAB's numerical ODE solver ODE45 to create a 
    %      plot of the solution: 
    %
    %      sol = ode45(M,[0 20],[2 0]);
    %      x = linspace(0,20,100);
    %      y = deval(sol,x,1);
    %      plot(x,y);
    %
    %
    %   See also DSOLVE, matlabFunction.

    %   Copyright 2011-2013 The MathWorks, Inc.

eng = symengine;
sol = mupadOdeToVectorField(varargin);
V = eng.feval('_index',sol,'"VectorFieldComponents"');
Y = eng.feval('_index',sol,'"Substitutions"');
    
function T = mupadOdeToVectorField(args)

narg = length(args);

% The default independent variable is t.
default_varname = true;
x = sym('t');

% Pick up the independent variable, if specified.
if isvarname(char(args{end}))
   default_varname = false;
   x = sym(args{end});
   args(end) = [];
   narg = narg-1;
end

sys = args(1:narg);
if ischar(sys{1}) 
    stringInput = '"stringInput"';
else
    stringInput = 'null()';
end

% Concatenate equation(s) into SYS.
sys_class = cellfun(@class,sys,'UniformOutput',false);
chars = strcmp(sys_class,'char');
sys_char = sys(chars);

% look for symfuns and pick out independent variable
sys_sym = [sys{~chars}];
syminputs = [];
if ~isempty(sys_sym) && isa(sys_sym,'symfun')
    syminputs = argnames(sys_sym);
end
if ~isempty(syminputs)
    if ~isscalar(syminputs)
        error(message('symbolic:dsolve:OneVar'));
    end
    if default_varname
        x = syminputs;
    else
        sys_sym = sys_sym(x);
    end
end
sys_char(2,:) = {','};
sys_str = ['[' sys_char{1:end-1} ']'];
sys = [sys_sym evalin(symengine, sys_str)];
T = feval(symengine,'symobj::odeToVectorField',sys,x,stringInput);
