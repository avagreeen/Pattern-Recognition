function r = combine(s, varargin)
% combine  Combine terms of the same algebraic structure.
%    combine(S)
%      tries to rewrite products of powers in the expression S as a
%      single power.
%    combine(S, T)
%      combines several calls to the target function T in the expression f
%      to a single call.
%      The target T is specified as one of the strings
%      'atan', 'exp', 'gamma', 'log', 'sincos', 'sinhcosh'.
%    combine(..., 'IgnoreAnalyticConstraints',VAL)
%      controls the level of mathematical rigor to use on the analytical
%      constraints while combining (branch cuts, division by zero, and so on).
%      Here, VAL can be TRUE or  FALSE. If you use TRUE, then combine uses
%      a set of mathematical rules, such as ln(a) + ln(b) = ln(a*b),
%      that are not generally correct, but can give simpler results.
%      The default is FALSE.
%
%    Examples:
%      combine(2^x * 3^x)  returns  6^x
%      combine((2^x)^i)    returns  (2^x)^i
%      combine((2^x)^i, 'IgnoreAnalyticConstraints', true)
%                          returns  2^(x*i)
%      combine(log(x) + log(y), 'log')
%                          returns  log(x) + log(y)
%      combine(log(x) + log(y), 'log', 'IgnoreAnalyticConstraints', true)
%                          returns  log(x*y)
%
%     See also sym/simplify, sym/expand, sym/factor

%   Copyright 2013-2014 The MathWorks, Inc.

p = inputParser;
addRequired(p, 's', @(X) isa(X, 'sym'));

targets = {'atan', 'exp', 'gamma', 'int', 'log', 'sincos', 'sinhcosh'};
if nargin >=2
    target = varargin{1};
    % interpret every character string not starting with 'I' or 'i' as a
    % target (possibly invalid)
    if ischar(target) && (isempty(target) || ~strcmpi(target(1), 'i') || strcmp(target, 'int'))
        secondArgumentIsTarget = true;
        addRequired(p, 'target', ...
            @(X) ismember(X, targets));
    else
        secondArgumentIsTarget = false;
    end
else
    secondArgumentIsTarget = false;
end

addParameter(p, 'IgnoreAnalyticConstraints', false);

parse(p, s, varargin{:});
res = p.Results;

if secondArgumentIsTarget
    % correct spelling
    res.target = validatestring(res.target, targets);
    % modify target according to MuPAD syntax
    if strcmp(res.target, 'atan')
        T = 'arctan';
    elseif strcmp(res.target, 'log')
        T = '[log, ln]';
    else
        T = res.target;
    end
else
    T = 'null()';
end

if sym.checkIgnoreAnalyticConstraintsValue(res.IgnoreAnalyticConstraints)
    T = [T ', IgnoreAnalyticConstraints'];
end

r = feval(symengine, 'combine', s, T);
% convert back to symfun if the input was symfun:
r = privResolveOutput(r, s);

end
