function y = sympref(varargin)
%SYMPREF Set and get symbolic preferences.
%   SYMPREF determines the preferences for some symbolic functions.
%   When these preferences are changed, the new values are used
%   immediately. They persist in future MATLAB sessions until they
%   are changed again.
%
%   CURRENT = SYMPREF returns a structure array with currently
%   used preferences. The values of the preferences are returned
%   as SYM objects.
%
%   CURRENT = SYMPREF(NAME) returns the current value of the
%   preference given by the string NAME as a SYM object OLD.
%   NAME takes the string inputs 'FourierParameters' or
%   'HeavisideAtOrigin'.
%
%   OLD = SYMPREF(NAME, NEW) sets the preference given by the
%   string NAME to the value NEW. The old value is returned in
%   the SYM object OLD.
%   For 'FourierParameters', the value NEW must be a numeric or
%   symbolic vector of length two. Its entries determine the
%   definition of the Fourier transform and its inverse used by
%   the functions FOURIER and IFOURIER. The default value is [1,-1].
%   For 'HeavisideAtOrigin', the value NEW must be a numeric scalar
%   or a scalar SYM object. It determines the result of the function
%   HEAVISIDE at the origin. Useful values are 0, 1/2, or 1. The
%   default value is 1/2.
%   For 'AbbreviateOutput', the value NEW must be convertible into a
%   logical scalar. If TRUE, the output of PRETTY and typesetting
%   output in Live Script use abbreviations.
%   For 'TypesetOutput', the value NEW must be convertible into a
%   logical scalar. If TRUE, the output of SYMs in Live Script will
%   use typesetting.
%
%   OLD = SYMPREF(NAME, 'default') sets the preference given
%   by the string NAME to its default value. The old value is
%   returned in the SYM object OLD.
%
%   OLD = SYMPREF('default') sets all preferences to their
%   default values and returns a structure array with the old
%   preferences given by SYM values.
%
%   OLD = SYMPREF(NEW) sets all preferences to values given by the
%   structure array NEW. Valid input structure arrays are given
%   by output values of SYMPREF or SYMPREF('default'). The old
%   values of preferences are returned in the structure array
%   array OLD that is also valid input for a call to SYMPREF.
%
%   You should change symbolic preferences only at the beginning
%   of a MATLAB session.
%
%   Example:
%     >> heaviside(0)
%        ans =
%
%            0.5000
%     Change heaviside(0) by setting a new preference:
%     >> old = sympref('HeavisideAtOrigin', 1);
%     >> heaviside(0)
%        ans =
%
%             1
%     Restore the original preference:
%     >> sympref('HeavisideAtOrigin', old);
%
%   See also DISP, DISPLAY, FOURIER, IFOURIER, HEAVISIDE, PRETTY.

%   Copyright 2014-2015 The MathWorks, Inc.

  narginchk(0,2);
  s = Settings;
  if ~s.existGroup('symbolic_internal')
     initializeSymprefs;
  end
  if nargin == 0
     y = getAllPrefs;
     return;
  end
  prefname = varargin{1};
  iSymprefs = implementedSymprefs;
  if nargin == 1 && isstruct(prefname);
     y = getAllPrefs;
     prefnames = fieldnames(prefname);
     prefvalues = struct2cell(prefname);
     prefnames = cellfun(@validateprefname,prefnames,'UniformOutput',false);

     % replace the strings 'default' by the default values
     pprefvalues = cellfun(@validateprefvalue,prefvalues,'UniformOutput',false);
     pos = strcmpi(pprefvalues(:), 'default');
     defaults = implementedSymprefs;
     prefvalues(pos) = defaults(pos,2);

     setSMTpref(prefnames, prefvalues);
     setMuPADpref(prefnames, prefvalues);
     return;
  end
  if ~ischar(prefname)
     error(message('symbolic:sympref:ExpectingString'));
  end
  if nargin == 1
     if strcmpi(prefname,'Initialize')
        initializeSymprefs;
        y = [];
     else
        prefname = validatestring(prefname,{iSymprefs{:,1},'default'});
        if strcmpi(prefname,'default')
          y = setSMTpref(iSymprefs(:,1), iSymprefs(:,2));
          setMuPADpref(iSymprefs(:,1), iSymprefs(:,2));
          y = cell2struct(y,iSymprefs(:,1),1);
        else
          currentPrefs = getAllPrefs;
          y = currentPrefs.(prefname);
        end
     end
  else % nargin == 2
     prefname = validatestring(prefname,iSymprefs(:,1));
     prefvalue = varargin{2};
     expectedType = expectedPrefType(prefname);
     if ischar(prefvalue)
        validatestring(prefvalue,{'default'});
        prefvalue = getDefault(prefname);
     end
     y = setSMTpref(prefname, prefvalue);
     try
       prefvalue = convert2expectedtype(prefvalue,expectedType);
       % check if prefvalue is accepted by MuPAD
       setMuPADpref(prefname, prefvalue);
     catch
       % restore the original prefvalue
       setSMTpref(prefname, y);
       error(message('symbolic:sympref:CannotSetPref', prefname));
     end
  end
end

% =====================================
% Add further settings/preferences here.
% Also add them to symprefValidator!
% =====================================
function y = implementedSymprefs
   y = {'FourierParameters', sym([1,-1]), 'MuPAD', 'sym';...
        'HeavisideAtOrigin', sym(1/2), 'MuPAD', 'sym';...
        'AbbreviateOutput', true, 'MuPAD', 'logical';...
        'TypesetOutput', true, 'SMT', 'logical';...
        };
end

function y = symprefValidator(prefname,prefvalue,expectedType)
    % do not allow string input
    switch expectedType
    case 'sym'
      if isnumeric(prefvalue)
        prefvalue = sym(prefvalue);
      end
      if isa(prefvalue, 'symfun')
        prefvalue = formula(prefvalue);
      end
      try
         prefvalue = sym(prefvalue);
      catch
         error(message('symbolic:sympref:ValueMustBeNumericOrSym', prefname));
      end
    case 'logical'
      try
         prefvalue = logical(prefvalue);
      catch
         error(message('symbolic:sympref:ValueMustBeLogical', prefname));
      end
      if ~isscalar(prefvalue)
         error(message('symbolic:sympref:ValueMustBeLogical', prefname));
      end
    end
    switch prefname
    case 'FourierParameters'
       if ~(isvector(prefvalue) && length(prefvalue)==2)
          error(message('symbolic:sympref:CannotSetPref', prefname));
       end
       if ~all(isfinite(prefvalue))
          error(message('symbolic:sympref:MustBeFinite', prefname));
       end
    case 'HeavisideAtOrigin'
       if ~isscalar(prefvalue)
          error(message('symbolic:sympref:CannotSetPref', prefname));
       end
       if ~isfinite(prefvalue)
          error(message('symbolic:sympref:MustBeFinite', prefname));
       end
    end
    y = prefvalue;
end

% =========================
% various further utilities
% =========================
function y = convert2basetype(x)
     if islogical(x)
        y=x;
        return;
     end
     y = ['symobj::fromString("' char(feval(symengine,'symobj::toString',x)) '",2)'];
end

function y = convert2expectedtype(x,expectedType)
if strcmp(expectedType, 'sym') && ischar(x)
    y = evalin(symengine, x);
else
    y = feval(expectedType, x);
end
end

function initializeSymprefs
   s = Settings;
   if ~s.existGroup('symbolic_internal')
      s.addNode('symbolic_internal','hidden');
   end
   group = s.symbolic_internal;
   iSymprefs = implementedSymprefs;
   for i=1:size(iSymprefs,1)
       prefname = iSymprefs{i,1};
       expectedType = iSymprefs{i,4};
       if ~group.existSetting(prefname)
          group.addKey(prefname,'hidden');
       end
       if ~group.isSet(prefname)
          group.set(prefname, convert2basetype(iSymprefs{i,2}));
       end
       try
          prefvalue = convert2expectedtype(group.get(prefname),expectedType);
          setMuPADpref(prefname, prefvalue);
       catch
          % if the prefvalue in the XML file is not accepted
          % by MuPAD, fall back to the default value
          setMuPADpref(prefname, convert2expectedtype(iSymprefs{i,2},expectedType));
          group.set(prefname, convert2basetype(iSymprefs{i,2}));
          warning(message('symbolic:sympref:CannotSetPref',prefname));
       end
   end
   return;
end

function y = validateprefname(prefname)
   iSymprefs = implementedSymprefs;
   y = validatestring(prefname, iSymprefs(:,1));
end

function y = validateprefvalue(prefvalue)
   if ischar(prefvalue)
     y = validatestring(prefvalue, {'default'});
   else
     y = prefvalue;
   end
end

function y = getAllPrefs
   s = Settings;
   group = s.symbolic_internal;
   iSymprefs = implementedSymprefs;
   for i=1:size(iSymprefs,1)
       prefname = iSymprefs{i,1};
       expectedType = iSymprefs{i,4};
       if group.existSetting(prefname) && group.isSet(prefname)
          iSymprefs{i,2} = convert2expectedtype(group.get(prefname),expectedType);
       end
   end
   y = cell2struct(iSymprefs(:,2),iSymprefs(:,1),1);
end

function y = setSMTpref(prefname, prefvalue)
   s = Settings;
   group = s.symbolic_internal;
   if ischar(prefname)
      if ~group.existSetting(prefname)
         group.addKey(prefname,'hidden');
      end
      expectedType = expectedPrefType(prefname);
      if ~group.isSet(prefname)
         y = getDefault(prefname);
      else
         try
            y = convert2expectedtype(group.get(prefname),expectedType);
         catch
            % The storarge was messed up.
            y = getDefault(prefname);
         end
      end
      prefvalue=symprefValidator(prefname,prefvalue,expectedType);
      group.set(prefname, convert2basetype(prefvalue));
   else
      assert(iscell(prefname) && iscell(prefvalue));
      y = cellfun(@setSMTpref,prefname,prefvalue,'UniformOutput',false);
   end
end

function setMuPADpref(prefname, prefvalue)
   if ischar(prefname)
      if isMuPADPref(prefname)
         if strcmpi(expectedPrefType(prefname), 'logical')
            if prefvalue
               prefvalue = 'TRUE';
            else
               prefvalue = 'FALSE';
            end
         end
         MuPADprefname = ['Pref::' lower(prefname(1)) prefname(2:end)];
         feval(symengine,MuPADprefname,prefvalue);
      end
   else
      assert(iscell(prefname) && iscell(prefvalue));
      cellfun(@setMuPADpref, prefname, prefvalue, 'UniformOutput',false);
   end
end

function y = getDefault(prefname)
   iSymprefs = implementedSymprefs;
   pos = strcmpi(iSymprefs(:,1),prefname);
   y = iSymprefs{pos,2};
end

function y = isMuPADPref(prefname)
   iSymprefs = implementedSymprefs;
   pos = strcmpi(iSymprefs(:,1),prefname);
   y = strcmpi(iSymprefs{pos,3},'MuPAD');
end

function y = expectedPrefType(prefname)
   iSymprefs = implementedSymprefs;
   pos = strcmpi(iSymprefs(:,1),prefname);
   y = iSymprefs{pos,4};
end
