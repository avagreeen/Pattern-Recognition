function H = taylortool(f)
%TAYLORTOOL A Taylor series calculator.
%
%   TAYLORTOOL is an interactive Taylor series calculator that
%   graphs a function f against the Nth partial sum of its
%   Taylor series over [-2*pi,2*pi]. The default values for f
%   and N are x*cos(x) and 7, respectively.
%
%   TAYLORTOOL(f) Graphs the function f versus the Nth
%   partial sum of the Taylor series for f over [-2*pi,2*pi].
%   The default value for N is 7.
%
%   Example:  taylortool('sin(tan(x)) - tan(sin(x))')
%
%   See also FUNTOOL.

%   Copyright 1993-2013 The MathWorks, Inc.

if nargin<1
    f='x*cos(x)';
end

%Convert and store the input
[errMsg,ud.f,ud.N,ud.a,ud.D1,ud.D2] = checkAndConvert(f,'7','0','-2*pi','2*pi');
if ~isempty(errMsg)
    error(errMsg);
end

%Calculate the Taylor series expansion
ud.t = getTaylorResult(ud.f,ud.N,ud.a);
if isempty(ud.t)
    error(message('symbolic:taylortool:NoExpansion',char(ud.f),num2str(ud.a)));
end

%Set loading flag
ud.isReady = false;

%Create the GUI
fig = createTaylorToolGUI(ud);

%Plot the function and the Taylor series expansion
taylorplot(fig);

clearLoadingFlag(fig);

if nargout>0
    H = fig;
end

%---------------------------%
function [errMsg,fsym,Ndouble,adouble,D1double,D2double] = checkAndConvert(f,N,a,D1,D2)
%checkAndConvert: Checks the f, N, a, and [D1,D2] input values and converts
%them to the proper format. We assume that N, a, D1, and D2 are strings but
%we make no assumptions on f. If there is an issue with one of the inputs,
%then an error message will be stored in errMsg. Otherwise errMsg will be
%empty.

errMsg = '';
fsym = [];
Ndouble = [];
adouble = [];
D1double = [];
D2double = [];

%Convert the values
try 
    if ischar(f)
       fsym = evalin(symengine, f);
    else
       fsym = formula(sym(f));
    end    
catch
    errMsg = message('symbolic:taylortool:InvalidExpression',char(f));
    return;
end
try
    Ndouble = double(eval(N));
catch
    errMsg = message('symbolic:taylortool:InvalidDegree');
    return;
end
try
    adouble = double(eval(a));
catch
    errMsg = message('symbolic:taylortool:InvalidPoint');
    return;
end
try
    D1double = double(eval(D1));
    D2double = double(eval(D2));
catch
    errMsg = message('symbolic:taylortool:InvalidRange');
    return;
end

%Check the values
fvars = symvar(fsym);
if ~isscalar(fsym)
    errMsg = message('symbolic:taylortool:InvalidExpression',char(fsym));
elseif any(ismember(fvars,[sym('inf'),sym('Inf'),sym('NaN'),sym('nan')])) || ~isfinite(fsym)
    errMsg = message('symbolic:sym:InputMustNotContainNaNOrInf');
elseif ~(isscalar(fvars) || isempty(fvars))
    errMsg = message('symbolic:taylortool:InvalidExpression',char(fsym));
elseif strcmp(char(feval(symengine,'symobj::hasUnknownFunction',fsym)),'TRUE')
    errMsg = message('symbolic:taylortool:UnknownFunction', char(fsym));
elseif ~isscalar(Ndouble) || ~isfinite(Ndouble) || Ndouble<0 || floor(real(Ndouble))~=Ndouble
    errMsg = message('symbolic:taylortool:InvalidDegree');
elseif ~isscalar(adouble) || ~isfinite(adouble) || real(adouble)~=adouble
    errMsg = message('symbolic:taylortool:InvalidPoint');
elseif ~isscalar(D1double) || ~isscalar(D2double) || ~all(isfinite([D1double,D2double])) || ...
        D1double>=D2double || any(real([D1double,D2double])~=[D1double,D2double])
    errMsg = message('symbolic:taylortool:InvalidRange');
end

%---------------------------%
function taylorResult = getTaylorResult(f,N,a)
%getTaylorResult: Returns the Taylor series expansion of f with order N and
%expansion point a upon success. Otherwise an empty sym is returned.

%Get variable
var = symvar(f);
varAsChar = char(var);
if isempty(var)
    varAsChar = 'x';
end

%Assume var is real
varAssumptions = assumptions(var);
var = sym(varAsChar,'real');

try
    taylorResult = taylor(f,var,'ExpansionPoint',a,'Order',N+1);
catch
    taylorResult = sym([]);
end
%Make sure to not allow imaginary output
if ~isequal(imag(taylorResult),sym(0))
    taylorResult = sym([]);
end

%Reset assumption on var
if(isempty(varAssumptions))
    sym(varAsChar,'clear');
else
    assume(varAssumptions);
end

%---------------------------%
function fig = createTaylorToolGUI(ud)
%createTaylorToolGUI: Opens the GUI for the Taylor series tool and uses
%ud.f (sym), ud.t (sym), ud.N (double), ud.a (double), ud.D1 (double), and
%ud.D1 (double) to place initial values on the GUI.

PointsPerPixel = 72/get(0,'ScreenPixelsPerInch');

var = symvar(ud.f);
varAsChar = char(var);
if isempty(var)
    varAsChar = 'x';
end

%fig: figure window for the GUI
fig = figure(...
    'Tag','Taylor Tool',...
    'Units','points',...
    'Position',[150 100 520 420]*PointsPerPixel,...
    'name',getString(message('symbolic:taylortool:ToolName')),...
    'NumberTitle','off',...
    'IntegerHandle','off',...
    'HandleVisibility','callback',...
    'ToolBar','none');

%plotPanel: uipanel to hold plotAxes
ud.Handle.plotPanel = uipanel('Parent',fig,...
    'Tag','plotPanel',...
    'Units','normalized',...
    'Position',[0 0.45 1 0.55],...
    'BorderType','none');

%plotAxes: axes for the plot which is placed in plotPanel
ud.Handle.plotAxes = axes('Parent',ud.Handle.plotPanel,...
    'Tag','plotAxes',...
    'Units','normalized');
title(ud.Handle.plotAxes,getString(message('symbolic:taylortool:PlotTitle')));

%seriesPanel: uipanel to hold seriesAxes
ud.Handle.seriesPanel = uipanel('Parent',fig,...
    'Tag','seriesPanel',...
    'Units','normalized',...
    'Position',[0 0.3 1 0.15],...
    'BorderType','none');

%seriesAxes: axes containing the seriesText
ud.Handle.seriesAxes = axes('Parent',ud.Handle.seriesPanel,...
    'Tag','seriesAxes',...
    'Units','normalized',...
    'Position',[0.1 0.1 0.8 0.8],...
    'HandleVisibility','off',...
    'Box','on',...
    'XTick',[],'YTick',[],...
    'Color',[0.8,0.8,0.8]);

%seriesText: text object containing the series string
ud.Handle.seriesText = text(0.01,0.5,['T_N(' varAsChar ') = ' texlabel(slen(char(ud.t)),70)],...
    'Parent',ud.Handle.seriesAxes,...
    'Tag','seriesText',...
    'Units','normalized',...
    'Interpreter','tex',...
    'FontSize',10);

%fTextPanel: uipanel to hold fTextLabel
ud.Handle.fTextPanel = uipanel('Parent',fig,...
    'Tag','fTextPanel',...
    'Units','normalized',...
    'Position',[0 0.2 1 0.1],...
    'BorderType','none');

%fTextLabel: text uicontrol 'f(x) = '
ud.Handle.fTextLabel = uicontrol('Parent',ud.Handle.fTextPanel,...
    'Tag','fTextLabel',...
    'Units','normalized',...
    'Position',[0.1 0.2 0.1 0.6],...
    'Style','text',...
    'String',['f(' varAsChar ') = '],...
    'HorizontalAlignment','right',...
    'FontSize', 12);

%fEditBox: edit uicontrol for f user input
ud.Handle.fEditBox = uicontrol('Parent',ud.Handle.fTextPanel,...
    'Tag','fEditBox',...
    'Units','normalized',...
    'Position',[0.2 0.1 0.7 0.8],...
    'Style','edit',...
    'String',char(ud.f),...
    'HorizontalAlignment','left',...
    'FontSize', 12,...
    'BackgroundColor',[1 1 1],...
    'Interruptible','off',...
    'Callback',@(~,~) actionGetValuesAndPlot(fig));

%NaDPanel: uipanel to hold all the N, a, D1, and D2 buttons and inputs
ud.Handle.NaDPanel = uipanel('Parent',fig,...
    'Tag','NaDPanel',...
    'Units','normalized',...
    'Position',[0 0.1 1 0.1],...
    'BorderType','none');

%NLabel: text uicontrol 'N = '
ud.Handle.NLabel = uicontrol('Parent',ud.Handle.NaDPanel,...
    'Tag','NLabel',...
    'Units','normalized',...
    'Position',[0.1 0.2 0.1 0.6],...
    'Style','text',...
    'String','N = ',...
    'HorizontalAlignment','right',...
    'FontSize', 12);

%NEditBox: edit uicontrol for N user input
ud.Handle.NEditBox = uicontrol('Parent',ud.Handle.NaDPanel,...
    'Tag','NEditBox',...
    'Units','normalized',...
    'Position',[0.2 0.1 0.09 0.8],...
    'Style','edit',...
    'String',int2str(ud.N),...
    'HorizontalAlignment','left',...
    'FontSize', 12,...
    'BackgroundColor',[1 1 1],...
    'Interruptible','off',...
    'Callback',@(~,~) actionGetValuesAndPlot(fig));

%NupButton: pushbutton for N+
ud.Handle.NupButton = uicontrol('Parent',ud.Handle.NaDPanel,...
    'Tag','NupButton',...
    'Units','normalized',...
    'Position',[0.29 0.5 0.04 0.5],...
    'Style','pushbutton',...
    'String','+',...
    'HorizontalAlignment','center',...
    'FontSize', 10,...
    'FontName','Courier',...
    'FontWeight','bold',...
    'Interruptible','off',...
    'Callback',@(~,~) actionIncrement(fig,'up'));

%NdownButton: pushbutton for N-
ud.Handle.NdownButton = uicontrol('Parent',ud.Handle.NaDPanel,...
    'Tag','NdownButton',...
    'Units','normalized',...
    'Position',[0.29 0 0.04 0.5],...
    'Style','pushbutton',...
    'String','-',...
    'HorizontalAlignment','center',...
    'FontSize', 10,...
    'FontName','Courier',...
    'FontWeight','bold',...
    'Interruptible','off',...
    'Callback',@(~,~) actionIncrement(fig,'down'));

%aLabel: text uicontrol 'a = '
ud.Handle.aLabel = uicontrol('Parent',ud.Handle.NaDPanel,...
    'Tag','aLabel',...
    'Units','normalized',...
    'Position',[0.33 0.2 0.075 0.6],...
    'Style','text',...
    'String','a = ',...
    'HorizontalAlignment','right',...
    'FontSize', 12);

%aEditBox: edit uicontrol for a user input
ud.Handle.aEditBox = uicontrol('Parent',ud.Handle.NaDPanel,...
    'Tag','aEditBox',...
    'Units','normalized',...
    'Position',[0.405 0.1 0.125 0.8],...
    'Style','edit',...
    'String',char(sym(ud.a)),...
    'HorizontalAlignment','left',...
    'FontSize', 12,...
    'BackgroundColor',[1 1 1],...
    'Interruptible','off',...
    'Callback',@(~,~) actionGetValuesAndPlot(fig));

%D1EditBox: edit uicontrol for D1 user input
ud.Handle.D1EditBox = uicontrol('Parent',ud.Handle.NaDPanel,...
    'Tag','D1EditBox',...
    'Units','normalized',...
    'Position',[0.555 0.1 0.125 0.8],...
    'Style','edit',...
    'String',char(sym(ud.D1)),...
    'HorizontalAlignment','right',...
    'FontSize', 12,...
    'BackgroundColor',[1 1 1],...
    'Interruptible','off',...
    'Callback',@(~,~) actionGetValuesAndPlot(fig));

%DLabel: text uicontrol '< x <'
ud.Handle.DLabel = uicontrol('Parent',ud.Handle.NaDPanel,...
    'Tag','DLabel',...
    'Units','normalized',...
    'Position',[0.68 0.2 0.095 0.6],...
    'Style','text',...
    'String',['< ' varAsChar ' <'],...
    'HorizontalAlignment','center',...
    'FontSize', 12);

%D2EditBox: edit uicontrol for a D2 user input
ud.Handle.D2EditBox = uicontrol('Parent',ud.Handle.NaDPanel,...
    'Tag','D2EditBox',...
    'Units','normalized',...
    'Position',[0.775 0.1 0.125 0.8],...
    'Style','edit',...
    'String',char(sym(ud.D2)),...
    'HorizontalAlignment','left',...
    'FontSize', 12,...
    'BackgroundColor',[1 1 1],...
    'Interruptible','off',...
    'Callback',@(~,~) actionGetValuesAndPlot(fig));

%buttonPanel: uipanel to hold all the Help, Reset, and Close buttons
ud.Handle.buttonPanel = uipanel('Parent',fig,...
    'Tag','buttonPanel',...
    'Units','normalized',...
    'Position',[0 0 1 0.1],...
    'BorderType','none');

%resetButton: pushbutton uicontrol for Help
ud.Handle.helpButton = uicontrol('Parent',ud.Handle.buttonPanel,...
    'Tag','helpButton',...
    'Units','normalized',...
    'Position',[0.4 0.2 0.15 0.6],...
    'Style','pushbutton',...
    'String',getString(message('symbolic:taylortool:Help')),...
    'Callback',@(~,~) doc('taylortool'));

%resetButton: pushbutton uicontrol for Reset
ud.Handle.resetButton = uicontrol('Parent',ud.Handle.buttonPanel,...
    'Tag','resetButton',...
    'Units','normalized',...
    'Position',[0.575 0.2 0.15 0.6],...
    'Style','pushbutton',...
    'String',getString(message('symbolic:taylortool:Reset')),...
    'Callback',@(~,~) actionReset(fig));

%closeButton: pushbutton uicontrol for Close
ud.Handle.closeButton = uicontrol('Parent',ud.Handle.buttonPanel,...
    'Tag','closeButton',...
    'Units','normalized',...
    'Position',[0.75 0.2 0.15 0.6],...
    'Style','pushbutton',...
    'String',getString(message('symbolic:taylortool:Close')),...
    'Callback',@(~,~) close(fig));

% Set the figure user data
set(fig,'UserData',ud);

%----------------------------------%
function S = slen(S)
% slen: Reduces the length of a Taylor series by removing
%   terms until the string is less than 60 characters long.
%
%   Example:
%     S = ['1+x+1/2*x^2-1/8*x^4-1/15*x^5-1/240*x^6+1/90*x^7+' ...
%          '31/5760*x^8+1/5670*x^9-2951/3628800*x^10-1/3150*x^11'];
%     slen(S)  returns
%         1+x+1/2*x^2-1/8*x^4-1/15*x^5-1/240*x^6+1/90*x^7+...-1/3150*x^11

% Determine where S has + or -.
tmp = cumsum((S == '(') - (S == ')'));
B = (S == '+' | S == '-') & (tmp == 0);

B1 = find(B == 1);
S1 = S;
for j = 1:length(B1)-1
    if length(S) < 60
        return;
    else
        S = [S(1:B1(end-j)) '...' S1(B1(end):end)];
    end
end

%----------------------------------%
function taylorplot(fig)
% taylorplot: plots a comparison of the function f(x) to the partial
% sum of order N of the Taylor series for f(x) about the basepoint a over
% the interval D = [D1,D2], in the figure window fig.  Here the partial sum
% of order N is,
%                  n
%                 d f              n
% T_N(x) = sum(  ---- (a) * (x - a) , n = 0 .. N )
%                   n
%                 dx
%
% Note that f, N, a, D1, and D2 are stored as fields of get(fig,'UserData')

ud = get(fig,'UserData');
h1 = ezplot(ud.Handle.plotAxes,char(ud.f),[ud.D1,ud.D2]);
set(h1,'Color','b'); % blue
hold(ud.Handle.plotAxes,'on');
ylim = get(ud.Handle.plotAxes,'YLim');
ydiff = diff(ylim);
h2 = ezplot(ud.Handle.plotAxes,char(ud.t),[ud.D1,ud.D2]);
set(h2,'Color','r','LineStyle','--','Linewidth',2); %red dotted
newylim = [ylim(1)-ydiff/2,ylim(2)+ydiff/2]; %show twice as much viewing area as the default
set(ud.Handle.plotAxes,'YLim',newylim);
title(ud.Handle.plotAxes,getString(message('symbolic:taylortool:PlotTitle')));
xlabel(ud.Handle.plotAxes,'');
hold(ud.Handle.plotAxes,'off');

%Put tag back (for some strange reason, the Tag gets cleared after plotting)
set(ud.Handle.plotAxes,'Tag','plotAxes');

drawnow;

%----------------------------------%
function ud = getUserDataAndSetLoadingFlag(fig)
%getUserDataAndSetLoadingFlag: Get figure UserData ud and sets ud.isReady=true
ud = get(fig,'UserData');
ud.isReady = false;
set(fig,'UserData',ud);

%----------------------------------%
function clearLoadingFlag(fig)
%clearLoadingFlag: Sets ud.isReady=false in the figure UserData
ud = get(fig,'UserData');
ud.isReady = true;
set(fig,'UserData',ud);

%----------------------------------%
function actionGetValuesAndPlot(fig)
%actionGetValuesAndPlot: Callback for all edit boxes

ud = getUserDataAndSetLoadingFlag(fig);

%Get and check user input
fstr = get(ud.Handle.fEditBox,'String');
Nstr = get(ud.Handle.NEditBox,'String');
astr = get(ud.Handle.aEditBox,'String');
D1str = get(ud.Handle.D1EditBox,'String');
D2str = get(ud.Handle.D2EditBox,'String');
[errMsg,ud.f,ud.N,ud.a,ud.D1,ud.D2] = checkAndConvert(fstr,Nstr,astr,D1str,D2str);

var = symvar(ud.f);
varAsChar = char(var);
if isempty(var)
    varAsChar = 'x';
end

%Get Taylor series result
if isempty(errMsg)
    ud.t = getTaylorResult(ud.f,ud.N,ud.a);
    if isempty(ud.t)
        errMsg = message('symbolic:taylortool:NoExpansion',char(ud.f),num2str(ud.a));
    end
end

%Update plot or error
if isempty(errMsg)
    set(ud.Handle.fTextLabel,'String',['f(' varAsChar ') = ']);
    set(ud.Handle.DLabel,'String',['< ' varAsChar ' <']);
    set(ud.Handle.seriesText,'String',['T_N(' varAsChar ') = ' texlabel(slen(char(ud.t)),70)]);
    set(fig,'UserData',ud);
    taylorplot(fig);
else
    errordlg(getString(errMsg));
    set(ud.Handle.seriesText,'String',getString(errMsg));
    drawnow;
end

clearLoadingFlag(fig);

%----------------------------------%
function actionReset(fig)
%actionReset: callback for resetButton

ud = getUserDataAndSetLoadingFlag(fig);

%Reset to defaults (except for f)
set(ud.Handle.NEditBox,'String','7');
set(ud.Handle.aEditBox,'String','0');
set(ud.Handle.D1EditBox,'String','-2*pi');
set(ud.Handle.D2EditBox,'String','2*pi');
drawnow;

%Plot again
actionGetValuesAndPlot(fig);

%----------------------------------%
function actionIncrement(fig,upOrDown)
%actionIncrement: Callback for NupButton and NdownButton

ud = getUserDataAndSetLoadingFlag(fig);

%Increase or decrease N
switch upOrDown
    case 'up'
        ud.N = ud.N + 1;
    case 'down'
        ud.N = ud.N - 1;
end
set(ud.Handle.NEditBox,'String',int2str(ud.N));
drawnow;

%Plot again
actionGetValuesAndPlot(fig);