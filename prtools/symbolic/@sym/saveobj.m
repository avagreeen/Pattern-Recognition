function y = saveobj(x)
%SAVEOBJ    Save symbolic object
%   Y = SAVEOBJ(X) converts symbolic object X into a form that can be
%   saved to disk safely.

%   Copyright 2008-2014 The MathWorks, Inc.

y = privResolveArgs(x);
y = y{1};
if ~isempty(regexp(x.s,'^symobj::fromString','ONCE'))
    y.s = x.s;
else
    s = mupadmex('symobj::toString', x.s, 0);
    y.s = ['symobj::fromString(' s ', 2)'];
end
