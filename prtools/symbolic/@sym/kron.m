function K = kron(X,Y)
%KRON   Symbolic Kronecker tensor product.
%   KRON(X,Y) is the Kronecker tensor product of X and Y.
%   The result is a large matrix formed by taking all possible
%   products between the elements of X and those of Y. For
%   example, if X is 2 by 3, then KRON(X,Y) is
%
%      [ X(1,1)*Y  X(1,2)*Y  X(1,3)*Y
%        X(2,1)*Y  X(2,2)*Y  X(2,3)*Y ]
%
%   X and Y must be SYM objects. 
%

%   Copyright 2013 The MathWorks, Inc. 

args = privResolveArgs(X,Y);
Xsym = formula(args{1});
Ysym = formula(args{2});

if ~ismatrix(Xsym) || ~ismatrix(Ysym)
    error(message('MATLAB:kron:TwoDInput'));
end

[ma,na] = size(Xsym);
[mb,nb] = size(Ysym);
[ia,ib] = meshgrid(1:ma,1:mb);
[ja,jb] = meshgrid(1:na,1:nb);

K = privsubsref(Xsym,ia,ja).*privsubsref(Ysym,ib,jb);
K = privResolveOutput(K,args{1});
