function rsums(f,a,b)
%RSUMS  Interactive evaluation of Riemann sums.
%   RSUMS(f) approximates the integral of f from 0 to 1 by Riemann sums.
%   RSUMS(f,a,b) and RSUMS(f,[a,b]) approximates the integral from a to b.
%   f can be a scalar sym representing a function of exactly one variable
%   or a symfun with one input argument.
%
%   Examples:
%       x = sym('x')
%       rsums(exp(-5*x^2))
%       rsums(symfun(x^2*cos(x),x),-3*pi/4,3*pi/4)

%   Copyright 1993-2013 The MathWorks, Inc. 

%Convert f to function handle
if ~isa(f,'function_handle')
	f = matlabFunction(sym(f));
end

if nargin == 1
    rsums(f);
else   
    %Convert a to double
    if isa(a,'sym') && strcmp(mupadmex('symobj::isfloatable',a.s,0),'FALSE')
        error(message('symbolic:rsums:InvalidInterval'));
    end
    a = double(a);
    if nargin == 2
        rsums(f,a);
    else
        %Convert b to double
        if isa(b,'sym') && strcmp(mupadmex('symobj::isfloatable',b.s,0),'FALSE')
            error(message('symbolic:rsums:InvalidInterval'));
        end
        b = double(b);
        rsums(f,a,b);
    end
end
end