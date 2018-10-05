function r = digits(d)
%DIGITS Set variable precision digits.
%   Digits determines the accuracy of variable precision numeric computations.
%   DIGITS, by itself, displays the current setting of Digits.
%   DIGITS(D) sets Digits to D for subsequent calculations. D is an
%      integer, or a string or sym representing an integer.
%   D = DIGITS returns the current setting of Digits. D is an integer.
%   OLD = DIGITS(NEW) sets Digits to NEW and returns the old setting of Digits in OLD.
%
%   See also VPA.

%   Copyright 1993-2015 The MathWorks, Inc.

if nargout == 1
    r = eval(mupadmex('DIGITS',0));
end

if nargin == 1
    if ischar(d)
        d = sym(d);
    end

    if ~isscalar(d)
        error(message('symbolic:digits:IncorrectInput'))
    end

    eng = symengine;
    dsym = d;
    if isnumeric(d)
        d = int2str(d);
        dsym = evalin(symengine, d);
    elseif isa(d, 'sym')
        dsym = eng.feval('round', dsym);
        d = char(dsym);
    else
        dsym = sym(d);
        d = char(dsym);
    end

    isInt = char(eng.feval('testtype',char(dsym),'DOM_INT'));
    if ~strcmp(isInt,'TRUE') || dsym <= 1 || dsym >= 2^29 + 1
        error(message('symbolic:digits:IncorrectInput'));
    end

    mupadmex(['DIGITS := ' d ':']);
    mupadmex(d,15);
elseif nargout == 0
        disp(' ');
        disp(getString(message('symbolic:digits:sprintf_Digits',mupadmex('DIGITS',0))))
        disp(' ');
end
end
