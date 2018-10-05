function rsums(f,a,b)
%RSUMS  Interactive evaluation of Riemann sums.
%   RSUMS(f) approximates the integral of f from 0 to 1 by Riemann sums.
%   RSUMS(f,a,b) and RSUMS(f,[a,b]) approximates the integral from a to b.
%   f can be a string, an inline function, an anonymous function, or
%   a function handle.
%
%   Examples:
%       rsums exp(-5*x^2)
%       rsums(@(x) x^2*cos(x),-3*pi/4,3*pi/4)

%   Copyright 1993-2013 The MathWorks, Inc.

narginchk(1,3);

%Initialize and check f
if ~isa(f,'function_handle')
	f = matlabFunction(sym(f));
end
if nargin(f)~=1
	error(message('symbolic:rsums:FunctionInOneVariable'));
end
ud.f = f;

%Initialize and check a and b
if nargin == 1
    ud.a = 0;
    ud.b = 1;
else
    %Get a and b
    if nargin == 2
        if ~isequal(size(a),[1,2])
            error(message('symbolic:rsums:InvalidInterval'));
        end
        b = a(2);
        a = a(1);
    elseif ~isscalar(a) || ~isscalar(b)
        error(message('symbolic:rsums:InvalidInterval'));
    end
    
    %Check that a and b can be converted to double
    if ~isnumeric(a) || ~isnumeric(b)
        error(message('symbolic:rsums:InvalidInterval'));
    end
    ud.a = double(a);
    ud.b = double(b);
    
    %Check for valid values for a and b
    if ~isfinite(ud.a) || ~isfinite(ud.b)
        error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
    elseif ~isreal(ud.a) || ~isreal(ud.b) || ud.a >= ud.b
        error(message('symbolic:rsums:InvalidInterval'));
    end
end

%Initialize the axes and controls
clf('reset');
sliderPanelSize = 0.1;
ud.Handle.axesPanel = uipanel('Parent',gcf,...
    'Tag','axesPanel',...
    'Units','normalized',...
    'Position',[0 sliderPanelSize 1 1-sliderPanelSize],...
    'BorderType','none');
ud.Handle.plotAxes = axes('Parent',ud.Handle.axesPanel,...
    'Tag','plotAxes');
ud.Handle.sliderPanel = uipanel('Parent',gcf,...
    'Tag','sliderPanel',...
    'Units','normalized',...
    'Position',[0 0 1 sliderPanelSize],...
    'BorderType','none');
ud.Handle.rsumsSlider = uicontrol('Parent',ud.Handle.sliderPanel,...
    'Tag', 'rsumsSlider',...
    'Units','normalized',...
    'Position',[0.15 0.5 0.7 0.5],...
    'Style','slider',...
    'min',2,...
    'max',128,...
    'value',10,...
    'Callback', @(v,l) plotrsums());

ud.isReady = false;
set(gcf,'UserData',ud);

%Plot function for the first time with default n=10
plotrsums();
end

function plotrsums()
%plotrsums: Plots the Riemann sums rectangles for f between [a,b] where f,
%a, and b are stored as fields in get(gcf,'UserData').

%Set loading flag
ud = get(gcf,'UserData');
ud.isReady = false;
set(gcf,'UserData',ud);

%Get user data
f = ud.f;
a = ud.a;
b = ud.b;
sliderValue = get(ud.Handle.rsumsSlider,'Value');

%Calculate new values
n = round(sliderValue);
x = a + (b-a)*(1/2:1:n-1/2)/n;
y = zeros(size(x));
for k = 1:length(x)
    y(k) = f(x(k));
end
r = (b-a)*sum(y)/n;

%Plot
axesH = ud.Handle.plotAxes;
bar(axesH,x,y,'Tag','BarGraph');
axis(axesH,[a b min(0,min(y)) max(0,max(y))]);
xlabel(axesH,int2str(n));
title(axesH,sprintf('%9.6f',r),'Interpreter','none');

%Put tag back
set(axesH,'Tag','plotAxes');

%Update and clear loading flag
drawnow;
ud.isReady = true;
set(gcf,'UserData',ud);
end