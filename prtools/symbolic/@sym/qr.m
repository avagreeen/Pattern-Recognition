function [Q,R,P] = qr(A,varargin)
%QR     QR factorization.
%
%   [Q,R] = qr(A), where A is an m-by-n sym matrix, produces an m-by-n 
%   upper triangular matrix R and an m-by-m unitary matrix Q so that 
%   A = Q*R.
%
%   [Q,R] = qr(A,0) or, equivalently, [Q,R] = qr(A,'econ') produces the 
%   "economy size" decomposition. If m>n, only the first n columns of Q
%   and the first n rows of R are computed. If m<=n, this is the same as 
%   [Q,R] = qr(A).
%
%   R = qr(A) computes a "Q-less qr decomposition" and returns the upper
%   triangular factor R. Note that R = CHOL(A'*A). Since Q is often nearly
%   full, this is preferred to [Q,R] = qr(A).
%
%   R = qr(A,0) or, equivalently, R = qr(A,'econ') produces "economy size" 
%   R. If m>n, R has only n rows. If m<=n, this is the same as R = qr(A).
% 
%   [Q,R,P] = qr(A) produces unitary Q, upper triangular R, and a
%   permutation matrix P so that A*P = Q*R. The column permutation P is
%   chosen so that ABS(DIAG(R)) is decreasing.
%
%   [Q,R,P] = qr(A,'matrix') is equivalent to [Q,R,P] = qr(A).
%
%   [Q,R,p] = qr(A,'vector') returns the permutation information as a
%   vector instead of a matrix. That is, p is a row vector so that
%   A(:,p) = Q*R. 
%
%   [Q,R,p] = qr(A,0) or, equivalently, [Q,R,p] = qr(A,'econ') produces 
%   an "economy size" decomposition in which p is a permutation vector,
%   so that A(:,p) = Q*R and ABS(DIAG(R)) is decreasing.
%
%   [C,R] = qr(A,B), where B has as many rows as A, returns C = Q'*B.
%   The least-squares solution to A*X = B is X = R\C.
%
%   [C,R] = qr(A,B,0) or, equivalently, [C,R] = qr(A,B,'econ') produces 
%   "economy size" results. If m>n, C and R have only n rows. If m<=n, 
%   this is the same as [C,R] = qr(A,B).
%
%   [C,R,P] = qr(A,B) returns a column permutation P so that ABS(DIAG(R))
%   is decreasing. The least-squares solution to A*X = B is X = P*(R\C).
%
%   [C,R,P] = qr(A,B,'matrix') is equivalent to [C,R,P] = qr(A,B).
%
%   [C,R,p] = qr(A,B,'vector') returns the permutation information as a
%   vector instead of a matrix.  That is, the least-squares solution to 
%   A*X = B is X(p,:) = R\C. 
%
%   [C,R,p] = qr(A,B,0) or, equivalently, [C,R,p] = qr(A,B,'econ') 
%   produces "economy size" results C, R and a permutation vector p so 
%   that ABS(DIAG(R)) is decreasing. The least-squares solution to 
%   A*X = B is X(p,:) = R\C.
%
%   ... = qr(..., 'real') suppresses symbolic calls of ABS or CONJ in
%   the output of qr. With this string flag, all numerical entries in 
%   A must be real. Symbolic entries involving variables are assumed 
%   to be real. The flag 'real' can be added to all calls described
%   above. This option simplifies the result and, for this reason, is 
%   highly recommended whenever A is (or is assumed to be) real.  
  
%   Copyright 2013 The MathWorks, Inc.

narginchk(1,4);

%Set defaults:
bMode = false;
realMode = false;
econMode = false;
vectorMode = false;

%Check flags and determine modes:
if nargin>1
    %Replace (non-symfun) 0 inputs with 'econ'
    varargin(cellfun(@(x) isequal(x,0) || isequal(x,vpa(0)) || isequal(x, sym(0)),varargin)) = {'econ'};
    
    %Check for B input
    if(~ischar(varargin{1}))
        bMode = true;
        if nargout < 2
            error(message('symbolic:sym:qr:NotEnoughOutputArguments'));
        end
        flagInputs = varargin(2:end);
    else
        flagInputs = varargin(1:end);
    end

    %Validate the flag inputs
    if(~iscellstr(flagInputs))
        error(message('symbolic:sym:qr:InvalidArguments'));
    end
    flagInputs = cellfun(@(x) validatestring(x,{'econ', 'matrix', 'vector', 'real'}),...
                         flagInputs,'UniformOutput',false);
    %Set and check modes
    realMode = any(strcmp(flagInputs,'real'));
    econMode = any(strcmp(flagInputs,'econ'));
    vectorMode = any(strcmp(flagInputs,'vector'));
    if(vectorMode && nargout ~= 3)
            error(message('symbolic:sym:chol:VectorOnlySupportedInCaseOfThreeOutputs'));
    end
    if(any(strcmp(flagInputs,'matrix')))
        if(nargout ~= 3)
            error(message('symbolic:sym:chol:MatrixOnlySupportedInCaseOfThreeOutputs'));
        elseif econMode 
            error(message('symbolic:sym:qr:EconImpliesVector'));
        elseif vectorMode
            error(message('symbolic:sym:qr:InvalidArguments'));
        end
    end
end

%Resolve inputs:
if bMode
    args = privResolveArgs(A, varargin{1});
    A = args{1};
    Asym = formula(A);
    Asize = size(Asym);
    B = args{2};
    Bsym = formula(B);
    Bsize = size(Bsym);
    if Bsize(1) ~= Asize(1)
        error(message('symbolic:sym:qr:RowDimensionsDoNotMatch'));
    end
else
    args = privResolveArgs(A);
    A = args{1};
    Asym = formula(A);
    Asize = size(Asym);
end

%Additional error checking:
if length(Asize)>2 || (bMode && length(Bsize)>2)
    error(message('symbolic:sym:qr:HighDimensionalArraysNotSupported'));
end
if any(~isfinite(privsubsref(Asym,':'))) || (bMode && any(~isfinite(privsubsref(Bsym,':'))))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

%Perform QR decomposition:
Psym = sym([]);
if isempty(Asym)
    if econMode
        Qsym = sym(eye(Asize(1), min(Asize)));
        Rsym = sym.empty(min(Asize), Asize(2));
    else
        Qsym = sym(eye(Asize(1), Asize(1)));
        Rsym = sym.empty(Asize(1), Asize(2));
    end
    Psym = sym(1:Asize(2));
elseif nargout < 3
    if (~econMode) && (~realMode)
        [Qsym,Rsym] = mupadmexnout('symobj::qr',Asym);
    elseif (~econMode) && realMode
        [Qsym,Rsym] = mupadmexnout('symobj::qr',Asym,'Real');
    elseif econMode && (~realMode)
        [Qsym,Rsym] = mupadmexnout('symobj::qr',Asym,'"EconomyMode"');
    else
        [Qsym,Rsym] = mupadmexnout('symobj::qr',Asym,'"EconomyMode"','Real');
    end
else
    if (~econMode) && (~realMode)
        [Qsym,Rsym,Psym] = mupadmexnout('symobj::qr',Asym,'"Pivoting"');
    elseif (~econMode) && realMode
        [Qsym,Rsym,Psym] = mupadmexnout('symobj::qr',Asym,'"Pivoting"','Real');
    elseif econMode && (~realMode)
        [Qsym,Rsym,Psym] = mupadmexnout('symobj::qr',Asym,'"Pivoting"','"EconomyMode"');
    else
        [Qsym,Rsym,Psym] = mupadmexnout('symobj::qr',Asym,'"Pivoting"','"EconomyMode"','Real');
    end
end

if nargout <= 1
    Qsym = Rsym;
elseif (nargout == 3) && (~vectorMode) && (~econMode)
    % convert the permutation vector Psym to a matrix
    if ~isempty(Psym)
        tmp = eye(length(Psym));
        Psym = sym(tmp(:,Psym));
    else
        Psym = sym.empty(length(Psym));
    end
end

if bMode
    if realMode
        Qsym = Qsym.'*Bsym;
    else
        Qsym = Qsym'*Bsym;
    end
end

Q = privResolveOutput(Qsym, A);
R = privResolveOutput(Rsym, A);
P = double(Psym);
end
