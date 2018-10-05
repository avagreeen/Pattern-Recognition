function [names,values,units]=symReadSSCVariables(componentName)
%symReadSSCVariables Load variables from a Simscape component
%   [names,values,units]=symSSCReadVariables(componentName) returns the names, values 
%   and units for all the variables from the given Simscape component.
%
%   names, values and units are each returned as a cell array of symbolic objects.
%   Here names{i}, values{i} and units{i} corresponds. So values{i} and units{i}
%   contain the value and the unit for the variable names{i}.
%
%   componentName is the name of a Simscape component. 
%   The component must be on the matlabpath or in the current directory, otherwise it is not found.
%
%   See also symReadSSCVariables, symWriteSSC

%   Copyright 2015 The MathWorks, Inc.

narginchk(1,1);

validateattributes(componentName, {'char'}, {'row'});

try
    variables=simscape.smt.variables(componentName);
catch ME
    if isequal(ME.identifier,'MATLAB:undefinedVarOrClass')
        error(message('symbolic:symSSC:SimscapeRequired'));
    elseif isequal(ME.identifier,'simscape:compiler:mli:service:InvalidModelType')
        error(message('symbolic:symSSC:DomainsNotSupported'));
    else
        rethrow(ME);
    end
end

names = cell(1,length(variables));
if nargout > 1 
    values = cell(1,length(variables));
end
if nargout > 2
    units = cell(1,length(variables));
end
for i = 1:length(variables)
    names{i}  = sym(variables(i).name);
    if nargout > 1 
        values{i} = sym(variables(i).value);
    end
    if nargout > 2
        units{i}  = feval(symengine, 'unit::convertUnits', ['"' variables(i).unit '"'], '#Simscape');
    end
end
