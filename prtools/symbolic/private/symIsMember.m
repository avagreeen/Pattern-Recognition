function varargout = symIsMember(varargin)
%ISMEMBER True for set member.
%   LIA = ISMEMBER(A,B) for arrays A and B returns an array of the same
%   size as A containing true where the elements of A are in B and false
%   otherwise.
%
%   LIA = ISMEMBER(A,B,'rows') for matrices A and B with the same number
%   of columns, returns a vector containing true where the rows of A are
%   also rows of B and false otherwise.
%
%   [LIA,LOCB] = ISMEMBER(A,B) also returns an array LOCB containing the
%   lowest absolute index in B for each element in A which is a member of
%   B and 0 if there is no such index.
%
%   [LIA,LOCB] = ISMEMBER(A,B,'rows') also returns a vector LOCB containing
%   the lowest absolute index in B for each row in A which is a member
%   of B and 0 if there is no such index.
%
%   The behavior of ISMEMBER has changed.  This includes:
%     -	occurrence of indices in LOCB switched from highest to lowest
%     -	tighter restrictions on combinations of classes
%
%   If this change in behavior has adversely affected your code, you may 
%   preserve the previous behavior with:
%
%      [LIA,LOCB] = ISMEMBER(A,B,'legacy')
%      [LIA,LOCB] = ISMEMBER(A,B,'rows','legacy')
%
%   Examples:
%
%      a = [9 9 8 8 7 7 7 6 6 6 5 5 4 4 2 1 1 1]
%      b = [1 1 1 3 3 3 3 3 4 4 4 4 4 9 9 9]
%
%      [lia1,locb1] = ismember(a,b)
%      % returns
%      lia1 = [1 1 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1]
%      locb1 = [16 16 0 0 0 0 0 0 0 0 0 0 13 13 0 3 3 3]
%
%      [lia2,locb2] = ismember(a,b,'R2012a')
%      % returns
%      lia2 = [1 1 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1]
%      locb2 = [14 14 0 0 0 0 0 0 0 0 0 0 9 9 0 1 1 1]
%
%      [lia,locb] = ismember([1 NaN 2 3],[3 4 NaN 1])
%      % NaNs compare as not equal, so this returns
%      lia = [1 0 0 1], locb = [4 0 0 1]
%
%   Class support for inputs A and B, where A and B must be of the same
%   class unless stated otherwise:
%      - logical, char, all numeric classes (may combine with double arrays)
%      - cell arrays of strings (may combine with char arrays)
%      -- 'rows' option is not supported for cell arrays
%      - objects with methods SORT (SORTROWS for the 'rows' option), EQ and NE
%      -- including heterogeneous arrays derived from the same root class
%
%   See also UNIQUE, UNION, INTERSECT, SETDIFF, SETXOR, SORT, SORTROWS.

%   Copyright 1984-2012 The MathWorks, Inc.

% Determine the number of outputs requested.
if nargout == 0
    nlhs = 1;
else
    nlhs = nargout;
end

narginchk(2,4);
nrhs = nargin;
if nrhs == 2
    [varargout{1:nlhs}] = ismemberR2012a(varargin{:});
else
    % acceptable combinations, with optional inputs denoted in []
    % ismember(A,B, ['rows'], ['legacy'/'R2012a'])
    nflagvals = 3;
    flagvals = {'rows' 'legacy' 'R2012a'};
    % When a flag is found, note the index into varargin where it was found
    flaginds = zeros(1,nflagvals);
    for i = 3:nrhs
        flag = varargin{i};
        foundflag = strcmpi(flag,flagvals);
        if ~any(foundflag)
            if ischar(flag)
                error(message('MATLAB:ISMEMBER:UnknownFlag',flag));
            else
                error(message('MATLAB:ISMEMBER:UnknownInput'));
            end
        end
        % Only 1 occurrence of each allowed flag value
        if flaginds(foundflag)
            error(message('MATLAB:ISMEMBER:RepeatedFlag',flag));
        end
        flaginds(foundflag) = i;
    end
    
    % Only 1 of each of the paired flags
    if flaginds(2) && flaginds(3)
        error(message('MATLAB:ISMEMBER:BehaviorConflict'))
    end
    % 'legacy' and 'R2012a' flags must be trailing
    if flaginds(2) && flaginds(2)~=nrhs
        error(message('MATLAB:ISMEMBER:LegacyTrailing'))
    end
    if flaginds(3) && flaginds(3)~=nrhs
        error(message('MATLAB:ISMEMBER:R2012aTrailing'))
    end
    
    if flaginds(3) % trailing 'R2012a' specified
        [varargout{1:nlhs}] = ismemberR2012a(varargin{1:2},logical(flaginds(1)));
    elseif flaginds(2) % trailing 'legacy' specified
        [varargout{1:nlhs}] = ismemberlegacy(varargin{1:2},logical(flaginds(1)));
    else % 'R2012a' (default behavior)
        [varargout{1:nlhs}] = ismemberR2012a(varargin{1:2},logical(flaginds(1)));
    end
end
end

function [tf,loc] = ismemberlegacy(a,s,isrows)
% 'legacy' flag implementation

if nargin == 3 && isrows
    flag = 'rows';
else
    flag = [];
end

numelA = numel(a);
numelS = numel(s);
nOut = nargout;
    % Handle objects that cannot be converted to doubles
    if isempty(flag)
        
        % Handle empty arrays and scalars.
        
        if numelA == 0 || numelS <= 1
            if (numelA == 0 || numelS == 0)
                tf = false(size(a));
                loc = zeros(size(a));
                return
                
                % Scalar A handled below.
                % Scalar S: find which elements of A are equal to S.
            elseif numelS == 1
                tf = logical(a == s);
                if nOut > 1
                    % Use DOUBLE to convert logical "1" index to double "1" index.
                    loc = double(tf);
                end
                return
            end
        else
            % General handling.
            % Use FIND method for very small sizes of the input vector to avoid SORT.
            scalarcut = 5;
            if numelA <= scalarcut
                tf = false(size(a));
                loc = zeros(size(a));
                if nOut <= 1
                    for i=1:numelA
                        tf(i) = any(a(i)==s);   % ANY returns logical.
                    end
                else
                    for i=1:numelA
                        found = find(a(i)==s);  % FIND returns indices for LOC.
                        if ~isempty(found)
                            tf(i) = 1;
                            loc(i) = found(end);
                        end
                    end
                end
            else
                
                % Duplicates within the sets are eliminated
                [au,~,an] = unique(a(:),'legacy');
                if nOut <= 1
                    su = unique(s(:),'legacy');
                else
                    [su,sm] = unique(s(:),'legacy');
                end
                
                % Sort the unique elements of A and S, duplicate entries are adjacent
                [c,ndx] = sort([au;su]);
                
                % Find matching entries
                d = c(1:end-1)==c(2:end);         % d indicates matching entries in 2-D
                d = find(d);                      % Finds the index of matching entries
                ndx1 = ndx(d);                    % NDX1 are locations of repeats in C
                
                if nOut <= 1
                    tf = ismember(an,ndx1,'legacy');         % Find repeats among original list
                else
                    szau = size(au,1);
                    [tf,loc] = ismember(an,ndx1,'legacy');   % Find loc by using given indices
                    newd = d(loc(tf));              % NEWD is D for non-unique A
                    where = sm(ndx(newd+1)-szau);   % Index values of SU through UNIQUE
                    loc(tf) = where;                % Return last occurrence of A within S
                end
            end
            tf = reshape(tf,size(a));
            if nOut > 1
                loc = reshape(loc,size(a));
            end
        end
        
    else    % 'rows' case
        
        rowsA = size(a,1);
        colsA = size(a,2); %#ok<NASGU>
        rowsS = size(s,1);
        colsS = size(s,2); %#ok<NASGU>
        
        % Automatically pad strings with spaces
        if size(a,2)~=size(s,2) && ~isempty(a) && ~isempty(s)
            error(message('MATLAB:ISMEMBER:AandBColnumAgree'));
        end
        
        % Empty check for 'rows'.
        if rowsA == 0 || rowsS == 0
            if (isempty(a) || isempty(s))
                tf = false(rowsA,1);
                loc = zeros(rowsA,1);
                return
            end
        end
        
        % Duplicates within the sets are eliminated
        if (rowsA == 1)
            au = repmat(a,rowsS,1);
            d = logical(au(1:end,:)==s(1:end,:));
            d = all(d,2);
            tf = any(d);
            if nOut > 1
                if tf
                    loc = find(d, 1, 'last');
                else
                    loc = 0;
                end
            end
            return;
        end
        [au,~,an] = unique(a,'rows','legacy');
        if nOut <= 1
            su = unique(s,'rows','legacy');
        else
            [su,sm] = unique(s,'rows','legacy');
        end
        
        % Sort the unique elements of A and S, duplicate entries are adjacent
        [c,ndx] = sortrows([au;su]);
        
        % Find matching entries
        d = c(1:end-1,:)==c(2:end,:);     % d indicates matching entries in 2-D
        d = find(all(d,2));               % Finds the index of matching entries
        ndx1 = ndx(d);                    % NDX1 are locations of repeats in C
        
        if nOut <= 1
            tf = ismember(an,ndx1,'legacy');         % Find repeats among original list
        else
            szau = size(au,1);
            [tf,loc] = ismember(an,ndx1,'legacy');   % Find loc by using given indices
            newd = d(loc(tf));              % NEWD is D for non-unique A
            where = sm(ndx(newd+1)-szau);   % Index values of SU through UNIQUE
            loc(tf) = where;                % Return last occurrence of A within S
        end
    end
end

function [lia,locb] = ismemberR2012a(a,b,options)
% 'R2012a' flag implementation

% Error check flag
if nargin == 2
    byrow = false;
else
    byrow = options > 0;
end

classFlag = true; %#ok<NASGU>

numelA = numel(a); %#ok<NASGU>

if ~byrow
        % Duplicates within the sets are eliminated
        if isscalar(a) || isscalar(b)
            ab = [a(:);b(:)];
            sort(ab(1));
            numa = numel(a);
            lia = logical(ab(1:numa)==ab(1+numa:end));   
            if ~any(lia)
                lia  = false(size(a));
                locb = zeros(size(a));
                return
            end
            if ~isscalar(b)
                locb = find(lia);
                locb = locb(1);
                lia = any(lia);
            else
                locb = double(lia);
            end
        else
        % Duplicates within the sets are eliminated
        [uA,~,icA] = unique(a(:),'sorted');
        if nargout <= 1
            uB = unique(b(:),'sorted');
        else
            [uB,ib] = unique(b(:),'sorted');
        end
        
        % Sort the unique elements of A and B, duplicate entries are adjacent
        [sortuAuB,IndSortuAuB] = sort([uA;uB]);
        
        % Find matching entries
        d = logical(sortuAuB(1:end-1)==sortuAuB(2:end));         % d indicates the indices matching entries
        ndx1 = IndSortuAuB(d);                          % NDX1 are locations of repeats in C
        
        if nargout <= 1
            lia = ismember(icA,ndx1,'R2012a');                   % Find repeats among original list
        else
            szuA = size(uA,1);
            d = find(d);
            [lia,locb] = ismember(icA,ndx1,'R2012a');            % Find locb by using given indices
            newd = d(locb(lia));                        % NEWD is D for non-unique A
            where = ib(IndSortuAuB(newd+1)-szuA);       % Index values of uB through UNIQUE
            locb(lia) = where;                          % Return first or last occurrence of A within B
        end
        end
        lia = reshape(lia,size(a));
        if nargout > 1
            locb = reshape(locb,size(a));
        end
    
else    % 'rows' case
    if ~(ismatrix(a) && ismatrix(b))
        error(message('MATLAB:ISMEMBER:NotAMatrix'));
    end
    
    [rowsA,colsA] = size(a);
    [rowsB,colsB] = size(b);
    
    % Automatically pad strings with spaces
    if colsA ~= colsB
        error(message('MATLAB:ISMEMBER:AandBColnumAgree'));
    end
    
    % Empty check for 'rows'.
    if rowsA == 0 || rowsB == 0
        lia = false(rowsA,1);
        locb = zeros(rowsA,1);
        return
    end
    
    % General handling for 'rows'.
    
    % Duplicates within the sets are eliminated
    if (rowsA == 1)
        uA = repmat(a,rowsB,1);
        d = logical(uA(1:end,:)==b(1:end,:));
        d = all(d,2);
        lia = any(d);
        if nargout > 1
            if lia
                locb = find(d, 1, 'first');
            else
                locb = 0;
            end
        end
        return;
    else
        [uA,~,icA] = unique(a,'rows','sorted');
    end
    if nargout <= 1
        uB = unique(b,'rows','sorted');
    else
        [uB,ib] = unique(b,'rows','sorted');
    end
    
    % Sort the unique elements of A and B, duplicate entries are adjacent
    [sortuAuB,IndSortuAuB] = sortrows([uA;uB]);
    
    % Find matching entries
    d = logical(sortuAuB(1:end-1,:)==sortuAuB(2:end,:));     % d indicates matching entries
    d = all(d,2);                                   % Finds the index of matching entries
    ndx1 = IndSortuAuB(d);                          % NDX1 are locations of repeats in C
    
    if nargout <= 1
        lia = ismember(icA,ndx1,'R2012a');           % Find repeats among original list
    else
        szuA = size(uA,1);
        [lia,locb] = ismember(icA,ndx1,'R2012a');    % Find locb by using given indices
        d = find(d);
        newd = d(locb(lia));                    % NEWD is D for non-unique A
        where = ib(IndSortuAuB(newd+1)-szuA);   % Index values of uB through UNIQUE
        locb(lia) = where;                      % Return first or last occurrence of A within B
    end
end
end
