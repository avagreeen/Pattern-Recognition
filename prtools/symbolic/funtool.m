function funtool()
%FUNTOOL A function calculator.
%   FUNTOOL is an interactive graphing calculator that manipulates
%   functions of a single variable.  At any time, there are two functions
%   displayed, f(x) and g(x).  The result of most operations replaces f(x).
%
%   The controls labeled 'f = ' and 'g = ' are editable text that may
%   be changed at any time to install a new function.  The control
%   labeled 'x = ' may be changed to specify a new domain.  The control
%   labeled 'a = ' may be changed to specify a new value of a parameter.
%
%   The top row of control buttons are unary function operators that
%   involve only f(x).  These operators are:
%      df/dx      - Symbolically differentiate f(x).
%      int f      - Symbolically integrate f(x).
%      simplify f - Simplify the symbolic expression, if possible.
%      num f      - Extract the numerator of a rational expression.
%      den f      - Extract the denominator of a rational expression.
%      1/f        - Replace f(x) by 1/f(x).
%      finv       - Replace f(x) by its inverse function.
%
%   The operators int(f) and finv may fail if the corresponding symbolic
%   expressions do not exist in closed form.
%
%   The second row of buttons translate and scale f(x) by the parameter 'a'.
%   The operations are:
%      f + a    - Replace f(x) by f(x) + a.
%      f - a    - Replace f(x) by f(x) - a.
%      f * a    - Replace f(x) by f(x) * a.
%      f / a    - Replace f(x) by f(x) / a.
%      f ^ a    - Replace f(x) by f(x) ^ a.
%      f(x+a)   - Replace f(x) by f(x + a).
%      f(x*a)   - Replace f(x) by f(x * a).
%
%   The third row of buttons are binary function operators that
%   operate on both f(x) and g(x).  The operations are:
%      f + g  - Replace f(x) by f(x) + g(x).
%      f - g  - Replace f(x) by f(x) - g(x).
%      f * g  - Replace f(x) by f(x) * g(x).
%      f / g  - Replace f(x) by f(x) / g(x).
%      f(g)   - Replace f(x) by f(g(x)).
%      g = f  - Replace g(x) by f(x).
%      swap   - Interchange f(x) and g(x).
%
%   The first three buttons in the fourth row manage a list of functions.
%   The Insert button places the current active function in the list.
%   The Cycle button rotates the function list.
%   The Delete button removes the active function from the list.
%   The list of functions is named fxlist.  A default fxlist containing
%           several interesting functions is provided.
%
%   The Reset button sets f, g, x, a and fxlist to their initial values.
%   The Help button prints this help text.
%
%   The Demo button poses the following challenge: Can you generate the
%   function sin(x) without touching the keyboard, using just the mouse?
%   The demo does it with a reset and then nine clicks.  If you can do
%   it with fewer clicks, please send e-mail to moler@mathworks.com.
%
%   The Close button closes all three windows.
%
%   See also EZPLOT.

%   Copyright 1993-2013 The MathWorks, Inc.

%Implementation Notes:
%   f,g, and a are syms.
%   x is a string. fxlist is a string matrix.
%
%   The values of f, g, a, and x are stored in the UserData of the text
%     objects "f", "g", "a", and "x", respectively. These text objects are
%     tagged "fLabel", "gLabel", "aLabel", and "xLabel", respectively.
%   fxlist is stored in the UserData of the Insert pushbutton object, which
%     is tagged as "InsertButton".
%   The edit text boxes for f, g, x, and a are tagged "fEditBox",
%     "gEditBox", "xEditBox", and "aEditBox", respectively.
%   The initial values of f, g, x, a, and fxlist are stored in a structure
%     called ud.init that has fields .f, .g, .x, .a and .l. The structure
%     is stored in the UserData of the control panel figure, which is
%      tagged as "funtoolFigure".

H = findobj(allchild(0),'flat','Tag','funtoolFigure');
if ~isempty(H)
    warning(message('symbolic:funtool:Started'));
    figure(H);
    Fhand = findobj(allchild(0),'flat','Tag','fFigure');
    Ghand = findobj(allchild(0),'flat','Tag','gFigure');
    figure(Fhand); figure(Ghand);
    return;
end

ud.init.f = 'x';
ud.init.g = '1';
ud.init.x = '[-2*pi, 2*pi]';
ud.init.a = '1/2';
ud.init.l = char( ...
    historyfmt('1/(5+4*cos(x))','[-2*pi, 2*pi]'), ...
    historyfmt('cos(x^3)/(1+x^2)','[-2*pi, 2*pi]'), ...
    historyfmt('x^4*(1-x)^4/(1+x^2)','[0, 1]'), ...
    historyfmt('x^7-7*x^6+21*x^5-35*x^4+35*x^3-21*x^2+7*x-1','[0.985, 1.015]'), ...
    historyfmt('log(abs(sqrt(x)))','[0, 2]'), ...
    historyfmt('tan(sin(x))-sin(tan(x))','[-pi, pi]'));

f = sym(ud.init.f);
g = sym(ud.init.g);
a = sym(ud.init.a);
x = ud.init.x;
fxlist = ud.init.l;

% Macros
blanks = '  ';
p = .12*(1:7) - .02;
q = .60 - .14*(1:4);
r = [.10 .10];

% Position the two figures and the control panel
ud.Handle.fFigure = figure('Tag','fFigure','Units','normalized','Position',[.01 .50 .45 .40], ...
    'Menu','none','Name','f', 'NumberTitle', 'off', ...
    'HandleVisibility','callback','CloseRequestFcn',@(~,~) closefuntool);
ud.Handle.gFigure = figure('Tag','gFigure','Units','normalized','Position',[.50 .50 .45 .40], ...
    'Menu','none','Name','g', 'NumberTitle', 'off', ...
    'HandleVisibility','callback','CloseRequestFcn',@(~,~) closefuntool);
ud.Handle.funtoolFigure = figure('Tag','funtoolFigure','Units','normalized','Position',[.25 .05 .48 .40], ...
    'Menu','none','Name', 'funtool', ...
    'NumberTitle', 'off', 'Color',get(0,'DefaultUIControlBackgroundColor'), ...
    'DefaultUIControlUnit','norm', ...
    'HandleVisibility','callback','CloseRequestFcn',@(~,~) closefuntool);

fig = ud.Handle.funtoolFigure;
ud.isReady = false;
ud.DemoIsRunning = false;
set(fig,'UserData',ud);

% Plot f(x) and g(x)
ezplotWithCatch(f,x,ud.Handle.fFigure);
ezplotWithCatch(g,x,ud.Handle.gFigure);

% Control panel
figure(fig);
ud.Handle.frame1 = uicontrol('Tag','frame1','Parent',fig, ...
    'Style','frame','Position',[0.01 0.60 0.98 0.38]);
ud.Handle.frame2 = uicontrol('Tag','frame2','Parent',fig, ...
    'Style','frame','Position',[0.01 0.01 0.98 0.58]);
ud.Handle.fLabel = uicontrol('Tag','fLabel','Parent',fig, ...
    'Style','text','Position',[0.04 0.86 0.09 0.10], ...
    'String','f = ','UserData',f);
ud.Handle.gLabel = uicontrol('Tag','gLabel','Parent',fig, ...
    'Style','text','Position',[0.04 0.74 0.09 0.10], ...
    'String','g = ','UserData',g);
ud.Handle.xLabel = uicontrol('Tag','xLabel','Parent',fig, ...
    'Style','text','Position',[0.04 0.62 0.09 0.10], ...
    'String','x = ','UserData',x);
ud.Handle.aLabel = uicontrol('Tag','aLabel','Parent',fig, ...
    'Style','text','Position',[0.54 0.62 0.09 0.10], ...
    'String','a = ','UserData',a);
ud.Handle.fEditBox = uicontrol('Tag','fEditBox','Parent',fig, ...
    'Style','edit','Position',[.12 .86 .82 .10], ...
    'HorizontalAlignment','left','BackgroundColor','white', ...
    'String',[blanks symchar(f)],'Callback',@(~,~) funtoolCB(fig,'fEditBoxCB'));
ud.Handle.gEditBox = uicontrol('Tag','gEditBox','Parent',fig, ...
    'Style','edit','Position',[.12 .74 .82 .10], ...
    'HorizontalAlignment','left','BackgroundColor','white', ...
    'String',[blanks symchar(g)],'Callback',@(~,~) funtoolCB(fig,'gEditBoxCB'));
ud.Handle.xEditBox = uicontrol('Tag','xEditBox','Parent',fig, ...
    'Style','edit','Position',[.12 .62 .32 .10], ...
    'HorizontalAlignment','left','BackgroundColor','white', ...
    'String',[blanks x],'Callback',@(~,~) funtoolCB(fig,'xEditBoxCB'));
ud.Handle.aEditBox = uicontrol('Tag','aEditBox','Parent',fig, ...
    'Style','edit','Position',[.62 .62 .32 .10], ...
    'HorizontalAlignment','left','BackgroundColor','white', ...
    'String',[blanks symchar(a)],'Callback',@(~,~) funtoolCB(fig,'aEditBoxCB'));

% Top row of unary operators
ud.Handle.difffButton = uicontrol('Tag','difffButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(1) q(1) r], ...
    'String','df/dx','Callback',@(~,~) funtoolCB(fig,'row1','df/dx'));
ud.Handle.intfButton = uicontrol('Tag','intfButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(2) q(1) r], ...
    'String','int f','Callback',@(~,~) funtoolCB(fig,'row1','int f'));
ud.Handle.simplifyfButton = uicontrol('Tag','simplifyfButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(3) q(1) r], ...
    'String','simplify f','Callback',@(~,~) funtoolCB(fig,'row1','simplify f'));
ud.Handle.numfButton = uicontrol('Tag','numfButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(4) q(1) r], ...
    'String','num f','Callback',@(~,~) funtoolCB(fig,'row1','num f'));
ud.Handle.denfButton = uicontrol('Tag','denfButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(5) q(1) r], ...
    'String','den f','Callback',@(~,~) funtoolCB(fig,'row1','den f'));
ud.Handle.oneoverfButton = uicontrol('Tag','oneoverfButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(6) q(1) r], ...
    'String','1/f','Callback',@(~,~) funtoolCB(fig,'row1','1/f'));
ud.Handle.finvButton = uicontrol('Tag','finvButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(7) q(1) r], ...
    'String','finv','Callback',@(~,~) funtoolCB(fig,'row1','finv'));

% Second row of unary operators
ud.Handle.fplusaButton = uicontrol('Tag','fplusaButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(1) q(2) r], ...
    'String','f+a','Callback',@(~,~) funtoolCB(fig,'row2','f+a'));
ud.Handle.fminusaButton = uicontrol('Tag','fminusaButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(2) q(2) r], ...
    'String','f-a','Callback',@(~,~) funtoolCB(fig,'row2','f-a'));
ud.Handle.ftimesaButton = uicontrol('Tag','ftimesaButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(3) q(2) r], ...
    'String','f*a','Callback',@(~,~) funtoolCB(fig,'row2','f*a'));
ud.Handle.foveraButton = uicontrol('Tag','foveraButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(4) q(2) r], ...
    'String','f/a','Callback',@(~,~) funtoolCB(fig,'row2','f/a'));
ud.Handle.ftotheaButton = uicontrol('Tag','ftotheaButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(5) q(2) r], ...
    'String','f^a','Callback',@(~,~) funtoolCB(fig,'row2','f^a'));
ud.Handle.fofxplusaButton = uicontrol('Tag','fofxplusaButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(6) q(2) r], ...
    'String','f(x+a)','Callback',@(~,~) funtoolCB(fig,'row2','f(x+a)'));
ud.Handle.fofxtimesaButton = uicontrol('Tag','fofxtimesaButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(7) q(2) r], ...
    'String','f(x*a)','Callback',@(~,~) funtoolCB(fig,'row2','f(x*a)'));

% Third row, binary operators
ud.Handle.fplusgButton = uicontrol('Tag','fplusgButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(1) q(3) r], ...
    'String','f + g','Callback',@(~,~) funtoolCB(fig,'row3','f + g'));
ud.Handle.fminusgButton = uicontrol('Tag','fminusgButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(2) q(3) r], ...
    'String','f - g','Callback',@(~,~) funtoolCB(fig,'row3','f - g'));
ud.Handle.ftimesgButton = uicontrol('Tag','ftimesgButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(3) q(3) r], ...
    'String','f * g','Callback',@(~,~) funtoolCB(fig,'row3','f * g'));
ud.Handle.fovergButton = uicontrol('Tag','fovergButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(4) q(3) r], ...
    'String','f / g','Callback',@(~,~) funtoolCB(fig,'row3','f / g'));
ud.Handle.fofgButton = uicontrol('Tag','fofgButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(5) q(3) r], ...
    'String','f(g)','Callback',@(~,~) funtoolCB(fig,'row3','f(g)'));
ud.Handle.gequalfButton = uicontrol('Tag','gequalfButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(6) q(3) r], ...
    'String','g = f','Callback',@(~,~) funtoolCB(fig,'row3','g = f'));
ud.Handle.swapButton = uicontrol('Tag','swapButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(7) q(3) r], ...
    'String',getString(message('symbolic:funtool:swap')), ...
    'Callback',@(~,~) funtoolCB(fig,'row3','swap'));

% Fourth row, auxiliary controls
ud.Handle.InsertButton = uicontrol('Tag','InsertButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(1) q(4) r], ...
    'String',getString(message('symbolic:funtool:Insert')), ...
    'UserData',fxlist,'Callback',@(~,~) funtoolCB(fig,'Insert'));
ud.Handle.CycleButton = uicontrol('Tag','CycleButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(2) q(4) r], ...
    'String',getString(message('symbolic:funtool:Cycle')), ...
    'Callback',@(~,~) funtoolCB(fig,'Cycle'));
ud.Handle.DeleteButton = uicontrol('Tag','DeleteButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(3) q(4) r], ...
    'String',getString(message('symbolic:funtool:Delete')), ...
    'Callback',@(~,~) funtoolCB(fig,'Delete'));
ud.Handle.ResetButton = uicontrol('Tag','ResetButton', 'Parent',fig, ...
    'Style','pushbutton','Position',[p(4) q(4) r], ...
    'String',getString(message('symbolic:funtool:Reset')), ...
    'Callback',@(~,~) funtoolCB(fig,'Reset'));
ud.Handle.HelpButton = uicontrol('Tag','HelpButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(5) q(4) r], ...
    'String',getString(message('symbolic:funtool:Help')), ...
    'Callback',@(~,~) doc('funtool'));
ud.Handle.DemoButton = uicontrol('Tag','DemoButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(6) q(4) r], ...
    'String',getString(message('symbolic:funtool:Demo')), ...
    'Callback',@(~,~) funtoolCB(fig,'Demo'));
ud.Handle.CloseButton = uicontrol('Tag','CloseButton','Parent',fig, ...
    'Style','pushbutton','Position',[p(7) q(4) r], ...
    'String',getString(message('symbolic:funtool:Close')), ...
    'Callback',@(~,~) closefuntool);

drawnow;
ud.isReady = true;
set(fig,'UserData',ud);

% -----------------------------------------------
function funtoolCB(fig,keyword,varargin)
ud = getUserDataAndSetLoadingFlag(fig);
blanks = '  ';

switch keyword
    %%%%%%%%%%%%%%%%%%%%%%%%%%  Callback for top row of unary operators.
    case 'row1'
        f = get(ud.Handle.fLabel,'UserData');
        x = get(ud.Handle.xLabel,'UserData');

        if isEmptyOrNonScalarSym(f)
            clearLoadingFlag(fig);
            return;
        end

        ok = true;
        switch varargin{1}
            case 'df/dx'
                f = diff(f);
            case 'int f'
                f = int(f);
                fchar = char(f);
                if isempty(f) || ~isempty(strfind(fchar,'root')) || ...
                        (length(fchar)>2 && isequal(fchar(1:3),'int'))
                    warndlg(getString(message('symbolic:funtool:NoIntegral')), ...
                        getString(message('symbolic:funtool:DialogTitle')));
                    ok = false;
                end
            case 'simplify f'
                f = simplify(f);
            case 'num f'
                [f,~] = numden(f);
            case 'den f'
                [~,f] = numden(f);
            case '1/f'
                f = 1/f;
            case 'finv'
                try
                    f = finverse(f);
                catch me
                    warndlg(getString(message('symbolic:funtool:NoInverse', me.message)), ...
                        getString(message('symbolic:funtool:DialogTitle')));
                    ok = false;
                end
                if isempty(f) || ~isempty(strfind(char(f),'root'))
                    warndlg(getString(message('symbolic:funtool:NoClosedInverse')), ...
                        getString(message('symbolic:funtool:DialogTitle')));
                    ok = false;
                end
        end

        if ok
            ezplotWithCatch(f,x,ud.Handle.fFigure);
            set(ud.Handle.fLabel,'UserData',f);
            set(ud.Handle.fEditBox,'String',[blanks symchar(f)]);
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%  Callback for second row of unary operators.
    case 'row2'
        f = get(ud.Handle.fLabel,'UserData');
        x = get(ud.Handle.xLabel,'UserData');
        a = get(ud.Handle.aLabel,'UserData');
        if isEmptyOrNonScalarSym(f) || isEmptyOrNonScalarSym(a)
            clearLoadingFlag(fig);
            return;
        end

        switch varargin{1}
            case 'f+a'
                f = f+a;
            case 'f-a'
                f = f-a;
            case 'f*a'
                f = f*a;
            case 'f/a'
                f = f/a;
            case 'f^a'
                f = f^a;
            case 'f(x+a)'
                var = symvar(f);
                f = subs(f,var,var+a);
            case 'f(x*a)'
                var = symvar(f);
                f = subs(f,var,var*a);
        end

        set(ud.Handle.fLabel,'UserData',f);
        ezplotWithCatch(f,x,ud.Handle.fFigure)
        set(ud.Handle.fEditBox,'String',[blanks symchar(f)]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%  Callback for third row, binary operators.
    case 'row3'
        % Get variables.
        f = get(ud.Handle.fLabel,'UserData');
        g = get(ud.Handle.gLabel,'UserData');
        x = get(ud.Handle.xLabel,'UserData');
        if isEmptyOrNonScalarSym(f) || isEmptyOrNonScalarSym(g)
            clearLoadingFlag(fig);
            return;
        end

        if strcmp(varargin{1}, 'g = f')
            g = f;
            set(ud.Handle.gLabel,'UserData',g);
            ezplotWithCatch(g,x,ud.Handle.gFigure)
            set(ud.Handle.gEditBox,'String',[blanks symchar(g)]);

        elseif strcmp(varargin{1}, 'swap')
            h = f; f = g; g = h;
            set(ud.Handle.fLabel,'UserData',f);
            ezplotWithCatch(f,x,ud.Handle.fFigure);
            set(ud.Handle.fEditBox,'String',[blanks symchar(f)]);
            set(ud.Handle.gLabel,'UserData',g);
            ezplotWithCatch(g,x,ud.Handle.gFigure);
            set(ud.Handle.gEditBox,'String',[blanks symchar(g)]);

        else
            switch varargin{1}
                case 'f + g'
                    f = f+g;
                case 'f - g'
                    f = f-g;
                case 'f * g'
                    f = f*g;
                case 'f / g'
                    f = f/g;
                case 'f(g)'
                    f = compose(f,g);
            end

            set(ud.Handle.fLabel,'UserData',f);
            ezplotWithCatch(f,x,ud.Handle.fFigure);
            set(ud.Handle.fEditBox,'String',[blanks symchar(f)]);
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%% Callback for F's edit text box.
    case 'fEditBoxCB'
        try
            fstr = strtrim(get(ud.Handle.fEditBox,'String'));
            f = evalin(symengine, fstr);
            set(ud.Handle.fEditBox,'String',[blanks fstr]);
            set(ud.Handle.fLabel,'UserData',f);
            x = get(ud.Handle.xLabel,'UserData');
            ezplotWithCatch(f,x,ud.Handle.fFigure);
        catch
            handleInvalidSym();
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%% Callback for G's edit text box.
    case 'gEditBoxCB'
        try
            gstr = strtrim(get(ud.Handle.gEditBox,'String'));
            g = evalin(symengine, gstr);
            set(ud.Handle.gEditBox,'String',[blanks gstr]);
            set(ud.Handle.gLabel,'UserData',g);
            x = get(ud.Handle.xLabel,'UserData');
            ezplotWithCatch(g,x,ud.Handle.gFigure);
        catch
            handleInvalidSym();
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%% Callback for A's edit text box.
    case 'aEditBoxCB'
        try
            astr = strtrim(get(ud.Handle.aEditBox,'String'));
            a = evalin(symengine, astr);
            set(ud.Handle.aEditBox,'String',[blanks astr]);
            set(ud.Handle.aLabel,'UserData',a);
        catch
            handleInvalidSym();
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%% Callback for X's edit text box.
    case 'xEditBoxCB'
        xstr = strtrim(get(ud.Handle.xEditBox,'String'));

        % Fix brackets
        xstr(xstr=='[' | xstr==']')=[];
        xstr = ['[' xstr ']'];
        
        set(ud.Handle.xEditBox,'String',[blanks xstr]);
        set(ud.Handle.xLabel,'UserData',xstr);

        f = get(ud.Handle.fLabel,'UserData');
        g = get(ud.Handle.gLabel,'UserData');

        ezplotWithCatch(f,xstr,ud.Handle.fFigure);
        ezplotWithCatch(g,xstr,ud.Handle.gFigure);

    %%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Insert button.
    case 'Insert'
        f = get(ud.Handle.fLabel,'UserData');
        x = get(ud.Handle.xLabel,'UserData');
        fxlist = get(ud.Handle.InsertButton,'UserData');
        fxlist = char(fxlist,historyfmt(f, x));
        set(ud.Handle.InsertButton,'UserData',fxlist);

    %%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Cycle button.
    case 'Cycle'

        % Get variables.
        fxlist = get(ud.Handle.InsertButton,'UserData');

        fx = fxlist(1,:);
        fx(fx==' ') = [];
        k = find(fx == ';');
        fstr = fx(1:k-1); f = evalin(symengine, fstr);
        set(ud.Handle.fLabel,'UserData',f);
        x = fx(k+1:length(fx));
        set(ud.Handle.xLabel,'UserData',x);

        set(ud.Handle.xEditBox,'String',[blanks x]);
        set(ud.Handle.fEditBox,'String',[blanks fstr]);
        ezplotWithCatch(f,x,ud.Handle.fFigure);
        k = [2:size(fxlist,1),1];
        fxlist = fxlist(k,:);
        set(ud.Handle.InsertButton,'UserData',fxlist);

    %%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Delete button.
    case 'Delete'

        % Get variables.
        f = get(ud.Handle.fLabel,'UserData');
        x = get(ud.Handle.xLabel,'UserData');
        fxlist = get(ud.Handle.InsertButton,'UserData');

        fx = historyfmt(f,x);
        fx(fx==' ') = [];
        for k = 1:size(fxlist,1),
            element = fxlist(k,:);
            element(element==' ') = [];
            if strcmp(fx,element)
                fxlist(k,:) = [];
                break;
            end
        end
        if isempty(fxlist)
            fxlist = '0-0;  [0,1]';
        end

        set(ud.Handle.InsertButton,'UserData',fxlist);

    %%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Reset button.
    case 'Reset'
        set(ud.Handle.fLabel,'UserData',sym(ud.init.f));
        set(ud.Handle.fEditBox,'String',[blanks ud.init.f]);
        ezplotWithCatch(sym(ud.init.f),ud.init.x,ud.Handle.fFigure);

        set(findobj(fig,'Tag','gLabel'),'UserData',sym(ud.init.g));
        set(ud.Handle.gEditBox,'String',[blanks ud.init.g]);
        ezplotWithCatch(sym(ud.init.g),ud.init.x,ud.Handle.gFigure);

        set(ud.Handle.xLabel,'UserData',ud.init.x);
        set(ud.Handle.xEditBox,'String',[blanks ud.init.x]);

        set(ud.Handle.aLabel,'UserData',sym(ud.init.a));
        set(ud.Handle.aEditBox,'String',[blanks ud.init.a]);

        set(ud.Handle.InsertButton,'UserData',ud.init.l);

        % Reset all buttons to default bkgd color.
        set(findobj(fig,'Style','pushbutton'),'BackgroundColor','default');

    %%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Demo button.
    case 'Demo'
        % "B" is the vector of button handles in the control panel.
        % "prog" is a "program" consisting of button codes.
        ud.DemoIsRunning = true;
        set(fig,'UserData',ud);
        prog = {'ResetButton','foveraButton','intfButton','fplusgButton','oneoverfButton', ...
            'intfButton','finvButton','intfButton','difffButton','numfButton'};
        B = findobj(fig,'Style','pushbutton');
        closeWasRequested = false;
        for k = 1: length(prog)
            try
                currB = findobj(B,'Tag',prog{k});
                set(currB,'BackgroundColor','white');
                theCB = get(currB,'Callback');
                theCB([],[]);
                pause(1);
                set(currB,'BackgroundColor','default');
            catch
                closeWasRequested = true;
                break;
            end
        end
        if(~closeWasRequested)
            ud.DemoIsRunning = false;
            set(fig,'UserData',ud);
        end
end % switch statement for Callbacks

clearLoadingFlag(fig);


% -----------------------------------------------
function s = historyfmt(f,x)
s = [symchar(f) ';' x];

function t=symchar(s)
if ~isa(s,'sym') 
    s = evalin(symengine, s);
end
t = char(s);

function ezplotWithCatch(s,x,fig)
C = onCleanup(@() set(fig,'Pointer','arrow'));
set(fig, 'Pointer','watch');
try
    ezplot(symchar(s),x,fig);
catch
    clf(fig);
    ax = axes('Parent',fig);
    text(.5,.5,getString(message('symbolic:funtool:NoPlot')),...
        'HorizontalAlignment','center','Tag',[get(fig,'Tag') '_errorText'],...
        'Parent',ax);
end

function handleInvalidSym()
errordlg(getString(message('symbolic:funtool:InvalidExpr')), ...
    getString(message('symbolic:funtool:ErrorDialogTitle')));

function res = isEmptyOrNonScalarSym(x)
res = false;
if isa(x,'sym') && (isempty(x) || ~isscalar(x))
    res = true;
    errordlg(getString(message('symbolic:funtool:NoPlot')), ...
        getString(message('symbolic:funtool:ErrorDialogTitle')));
end

function closefuntool()
    delete(findobj(allchild(0),'flat','Tag','fFigure'));
    delete(findobj(allchild(0),'flat','Tag','gFigure'));
    delete(findobj(allchild(0),'flat','Tag','funtoolFigure'));

function ud = getUserDataAndSetLoadingFlag(fig)
ud = get(fig,'UserData');
ud.isReady = false;
set(fig,'UserData',ud);

function clearLoadingFlag(fig)
if(ishghandle(fig))
    drawnow;
    ud = get(fig,'UserData');
    if(~ud.DemoIsRunning)
        ud.isReady = true;
        set(fig,'UserData',ud);
    end
end