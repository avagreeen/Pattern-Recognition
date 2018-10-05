function hh = ezplot(f,varargin)
%EZPLOT Easy to use function plotter.
%   EZPLOT(f) plots the expression f = f(x) over the default
%   domain -2*pi < x < 2*pi.
%
%   EZPLOT(f, [a,b]) plots f = f(x) over a < x < b.
%
%   For implicitly defined functions, f = f(x,y) or equations
%   EZPLOT(f) plots f(x,y) = 0 over the default domain
%   -2*pi < x < 2*pi and -2*pi < y < 2*pi. If f is an equation
%   then EZPLOT plots (x,y) points satisfying the equation.
%   EZPLOT(f, [xmin,xmax,ymin,ymax]) plots f over
%   xmin < x < xmax and  ymin < y < ymax.
%   EZPLOT(f, [a,b]) plots f over a < x < b and a < y < b.
%   If f is a function of the variables u and v (rather than x and y), then
%   the domain endpoints a, b, c, and d are sorted alphabetically. Thus,
%   EZPLOT(u^2 - v^2 == 1, [-3,2,-2,3]) plots u^2 - v^2 = 1 over
%   -3 < u < 2, -2 < v < 3.
%
%   EZPLOT(x,y) plots the parametrically defined planar curve x = x(t)
%   and y = y(t) over the default domain 0 < t < 2*pi.
%   EZPLOT(x,y, [tmin,tmax]) plots x = x(t) and y = y(t) over
%   tmin < t < tmax.
%
%   EZPLOT(f, [a,b], FIG}, EZPLOT(f, [xmin,xmax,ymin,ymax], FIG), or
%   EZPLOT(x,y, [tmin,tmax], FIG) plots the given function over the
%   specified domain in the figure window FIG.
%
%   Examples:
%     syms x y t
%     ezplot(cos(x))
%     ezplot(cos(x), [0, pi])
%     ezplot(x^2 - y^2 == 1)
%     ezplot(x^2 + y^2 == 1,[-1.25,1.25],3); axis equal
%     ezplot(1/y-log(y)+log(-1+y)+x == 1)
%     ezplot(x^3 + y^3 - 5*x*y == 1/5,[-3,3])
%     ezplot(x^3 + 2*x^2 - 3*x + 5 == y^2)
%     ezplot(sin(t),cos(t))
%     ezplot(sin(3*t)*cos(t),sin(3*t)*sin(t),[0,pi])

%   Copyright 1993-2011 MathWorks, Inc.

if ischar(f) || isa(f,'sym') 
    if size(symvar(sym(f)),2) > 2 
        error(message('symbolic:ezhelper:ExpectingAtMostTwoVariables'));
    end
end

if ~isempty(varargin) 
    g = varargin{1};
    if ischar(g) || isa(g,'sym') 
        if size(symvar([sym(f) sym(g)]),2) > 1 
            error(message('symbolic:ezhelper:ExpectingOneCurveParameter'));
        end
    end
end

switch length(varargin)
case 0
   % ezplot(f) or ezplot(f(x,y) = 0) -> use default setting.
   h = ezplot(fhandle(f));
   title(texlabel(f));
case 1
   % ezplot(x,y)
   y = varargin{1};
   if length(y) == 1
      h = ezplot(fhandle(f),fhandle(y));
   % ezplot(f(x,y) = 0,[xmin,xmax,ymin,ymax])
   elseif isa(y,'sym')
       error(message('symbolic:ezhelper:TooManySyms'));
   else
   % ezplot(f,[xmin,ymin]) and ezplot(f,[xmin,xmax,ymin,ymax]) covered in the default setting.
      h = ezplot(fhandle(f),varargin{:});
      title(texlabel(f));
   end
case 2
   % ezplot(x,y,domain)
   y = varargin{1};
   dom = varargin{2};
   checkNoSyms(varargin(2));
   if (length(y) == 1) && (length(dom) > 1)
      h = ezplot(fhandle(f),fhandle(y),dom);
   else
   % ezplot(f,xmin,ymin), ezplot(f,[xmin,xmax],fig), or 
   % ezplot(f(x,y) = 0,[xmin,xmax],[ymin,ymax])
      h = ezplot(fhandle(f),varargin{:});
      title(texlabel(f));
   end
otherwise
   y = varargin{1};
   checkNoSyms(varargin(2:end));
   h = ezplot(fhandle(f),fhandle(y),varargin{2:end});
end
if nargout > 0
   hh = h;
end
end

function checkNoSyms(args)
    if any(cellfun(@(arg)isa(arg,'sym'),args))
        error(message('symbolic:ezhelper:TooManySyms'));
    end
end

function f = fhandle(s)
  var = symvar(s);
  f = char(s);
  if strcmp(char(feval(symengine,'type',s)),'_equal')
      if length(var) ~= 2
          error(message('symbolic:ezhelper:DimensionMismatch'));
      end
      c = children(s);
      f = [char(privsubsref(c,1)) '-(' char(privsubsref(c,2)) ')'];
  end
  %if isempty(var)
  %    f = matlabFunction(funs,'vars',{'x'});
  %else
  %    f = matlabFunction(funs);
  %end
end
