function R = rewrite(S,T)
%REWRITE    Rewrite symbolic expressions S in terms of target T.
%   REWRITE(S,T) rewrites the symbolic expression S in terms of 
%     the target T. The target T is specified as one of the strings 
%     'exp', 'log', 'sincos', 'sin', 'cos', 'tan', 'sqrt', 'heaviside'. 
%
%   REWRITE(S,'exp') rewrites all trigonometric and hyperbolic 
%     functions in terms of EXP. Furthermore, the inverse functions 
%     as well as ARG are rewritten in terms of LOG.
%
%   REWRITE(S,'log') rewrites the functions ASIN, ACOS, ATAN, ACOT, 
%     ASINH, ACOSH, ATANH, ACOTH, ARG in terms of LOG.
% 
%   REWRITE(S,'sincos') rewrites the functions TAN, COT, EXP, SINH,
%     COSH, TANH and COTH in terms of SIN and COS.
% 
%   REWRITE(S,'sin') does the same as REWRITE(S,'sincos'). In addition
%     to that, cos(x)^2 is rewritten as 1-sin(x)^2. 
% 
%   REWRITE(S,'cos') does the same as REWRITE(S,'sincos'). In addition
%     to that, sin(x)^2 is rewritten as 1-cos(x)^2. 
%  
%   REWRITE(S,'tan') rewrites the functions SIN, COS, COT, EXP, SINH, 
%     COSH, TANH, COTH in terms of TAN. 
%  
%   REWRITE(S,'sqrt') rewrites complex absolute values abs(x+i*y) as
%     sqrt(x^2 + y^2) if x and y are real symbolic expressions.  
%
%   REWRITE(S,'heaviside') rewrites the function SIGN in terms of 
%     HEAVISIDE. 
% 
%   Examples:
%      syms x;
%
%      rewrite(sin(x),'exp') returns i/(2*exp(x*i)) - (exp(x*i)*i)/2
% 
%      rewrite(i/(2*exp(x*i))-(exp(x*i)*i)/2,'sincos') returns sin(x)
%
%      rewrite(asinh(x),'log') returns log(x + (x^2 + 1)^(1/2))
% 
%      rewrite((1/exp(x*i))*(1/2+i/2)+exp(x*i)*(1/2+(-i/2)),...
%               'sincos') returns cos(x) + sin(x)
% 
%      rewrite(tan(x),'sin') returns -sin(x)/(2*sin(x/2)^2 - 1)
% 
%      rewrite(tan(x),'sincos') returns sin(x)/cos(x)
%    
%      rewrite(sym('sign(x)'),'heaviside') returns 2*heaviside(x) - 1
%
%      syms x y real; 
%      rewrite(abs(x+1i*y),'sqrt') returns (x^2 + y^2)^(1/2)
%
%   See also SYM/SIMPLIFY, SYM/FACTOR, SYM/COLLECT, 
%   SYM/SIMPLIFYFRACTION.

%   Copyright 2011 The MathWorks, Inc.

p = inputParser;
p.addRequired('S', @(x) isa(x,'sym')); 
p.addRequired('T', @(x) any(strcmp(x, {'sin','cos','tan','sincos',...
                                       'exp','log','heaviside','sqrt'})));
p.parse(S,T);

S = privResolveArgs(S);
S = S{1};

Rsym = mupadmex('rewrite',S.s,T);                           
R = privResolveOutput(Rsym, S);
end
