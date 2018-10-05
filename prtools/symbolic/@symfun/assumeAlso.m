function assumeAlso(~, ~)
%assumeAlso Add symbolic assumption.
%   assumeAlso(COND) sets the condition COND to be true
%   in addition to all previous assumptions.
%   Assumptions on symfuns are not allowed.
%
%   See also SYM/ASSUMEALSO.
            
%   Copyright 2014 The MathWorks, Inc.
    error(message('symbolic:sym:AssumptionOnFunctionsNotSupported'));
end
