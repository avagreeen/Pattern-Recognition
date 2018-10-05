function display(X,namestr) %#ok<DISPLAY>
%DISPLAY Display function for syms.

%   Copyright 1993-2015 The MathWorks, Inc.

% get the correct number of digits to display for symfuns:
numbers = regexp(X(1).s, '^_symans_(\d+)', 'tokens');
if ~isempty(numbers)
  oldDigits = digits(numbers{1}{1});
  resetDigits = onCleanup(@() digits(oldDigits));
end

Xsym = privResolveArgs(X);
X = Xsym{1};
if nargin < 2
    namestr = inputname(1);
end
if isempty(namestr)
    namestr = 'ans';
end
if isa(X,'symfun')
    vars = argnames(X);
    cvars = privToCell(vars);
    cvars = cellfun(@char,cvars,'UniformOutput',false);
    vars = sprintf('%s, ',cvars{:});
    vars(end-1:end)=[];
    namestr = [namestr '(' vars ')'];
end
fX = formula(X);

sz = size(fX);
if prod(sz) == 0
    if isequal(sz,[0,0])
        str = getString(message('symbolic:sym:disp:EmptySym'));
    else
        by = getString(message('symbolic:sym:disp:by'));
        parts = arrayfun(@(x){int2str(x)},sz);
        parts(2,1:length(sz)-1) = {by};
        str = [parts{:}];
        str = getString(message('symbolic:sym:disp:EmptySymWithSize',str));
    end
    displayVariable(namestr,str);
    return;
end

if isempty(fX) || ndims(fX) <= 2
   displayVariable(namestr,X,true);
else
   p = size(fX);
   p = p(3:end);
   for k = 1:prod(p)
       sub = privsubsref(X,':',':',k);
       displayVariable([namestr '(:,:,' int2strnd(k,p) ')'],sub,false);
   end
end

% ------------------------

function s = int2strnd(k,p)
s = '';
k = k-1;
for j = 1:length(p)
   d = mod(k,p(j));
   s = [s int2str(d+1) ',']; %#ok<AGROW>
   k = (k - d)/p(j);
end
s(end) = [];


function displayVariable(varname,value,novars)
if feature('SuppressCommandLineOutput') && sympref('TypesetOutput')
   matlab.internal.language.signalVariableDisplay(value,varname);
else
   loose = isequal(get(0,'FormatSpacing'),'loose');
   if loose, disp(' '), end
   disp([varname ' =']);
   if loose, disp(' '), end
   if nargin < 3
      disp(value)
      if loose, disp(' '), end
   else
      disp(value,novars)
   end
end

