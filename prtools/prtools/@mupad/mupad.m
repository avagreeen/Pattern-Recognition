classdef mupad < handle
    %MUPAD Start MuPAD notebook interface
    %    NB = MUPAD opens a new blank MuPAD notebook and returns an object
    %    representing the notebook. A MuPAD notebook is a convenient environment
    %    for performing computations symbolically using the MuPAD language and
    %    documenting the results.
    %    NB = MUPAD(FILE) opens the notebook with file name FILE.
    %
    %    See also: sym, setVar, getVar
    
    %    Copyright 2008-2011 The MathWorks, Inc.
    
    properties(GetAccess='private',SetAccess='private')
        name = '';
    end
    methods(Hidden=true)
        function addlistener(obj,varargin)
            notUsed(obj,'addlistener');
        end
        function y=gt(obj,b) %#ok<STOUT,INUSD>
            notUsed(obj,'gt');
        end
        function y=ge(obj,b) %#ok<STOUT,INUSD>
            notUsed(obj,'ge');
        end
        function y=le(obj,b) %#ok<STOUT,INUSD>
            notUsed(obj,'le');
        end
        function y=lt(obj,b) %#ok<STOUT,INUSD>
            notUsed(obj,'lt');
        end
        function y=findobj(obj,varargin) %#ok<STOUT>
            notUsed(obj,'findobj');
        end
        function y=findprop(obj,varargin) %#ok<STOUT>
            notUsed(obj,'findprop');
        end
        function y=notify(obj,varargin) %#ok<STOUT>
            notUsed(obj,'notify');
        end
        function notUsed(~,op) 
            error(message('symbolic:mupad:UnsupportedOperation', op));
        end
    end
    methods
        function nb = mupad(varargin)
            symengine;
            switch nargin 
                case 0
                    nb.name = mupaduimex('NewNotebook');
                case 1
                    file = varargin{1};
                    fbase = file;
                    target = [strfind(file,'.mn#')  strfind(file,'.MN#')];
                    if ~isempty(target)
                        fbase = file(1:(target(1)+2));
                    end
                    if ~exist(fbase,'file')
                        error(message('symbolic:mupad:InvalidFile', fbase));
                    end

                    [~,~,ext] = fileparts(fbase);
                    if ~strcmpi(ext, '.mn')
                        error(message('symbolic:mupad:UnsupportedFileExtension'));
                    end

                    file = prependpwd(file);

                    if isunix && ~ismac && ~isempty(target)
                        % On Linux jumping to a target must be done one event cycle
                        % later then opening to make sure that the text engine
                        % is properly initialized. Otherwise it may crash rarely.
                        % Until there is a final solution inside of mupad or mupaduimex 
                        % this workaround fixes the BP in g808593.    
                        fbase = prependpwd(fbase);
                        nb.name = mupaduimex('OpenNotebook', fbase);
                    end

                    nb.name = mupaduimex('OpenNotebook', file);

                case 2
                    % Used only internally 
                    if strcmp(varargin{1}, '-fromUuid')
                        % Create notebook with given uuid.
                        nb.name = varargin{2};
                    else
                        error(message('symbolic:mupad:TooManyInputArguments'));
                    end
                otherwise
                    error(message('symbolic:mupad:TooManyInputArguments'));
            end
            
            
        end
        
        function disp(nb)
            if isempty(nb)
                disp(getString(message('symbolic:mupad:EmptyMuPAD')))
            end
            n=arrayfun(@(h) mupaduimex('GetWindowTitle', h.name), nb, 'UniformOutput', false);
            if any(cellfun(@isempty,n))
                error(message('symbolic:mupad:InvalidNotebookHandle'));
            end
            cellfun(@(h) disp(char(h)), n);
        end
        
    end
end

