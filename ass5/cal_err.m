function [ e] = cal_err( feat,theta,y,X_test,weight)
%CAL_ERR Summary of this function goes here
%   Detailed explanation goes here

if nargin==4
    lab= getlab(X_test);
    X = getdata(X_test);
    weight = ones(size(X_test,1),1)/size(X_test,1);
end
if nargin==5
    lab = getlab(X_test);
    X = getdata(X_test);

end
%X=getdata(X_test)
%lab=getlab(X_test)

weight = weight/sum(weight);
n = size(X_test,1);
if y==0
    predict=X(:,feat)<=theta;
else
    predict=X(:,feat)>=theta;
end

e=weight'*abs(predict-lab);


end

