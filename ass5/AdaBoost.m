function [preLab,beta,parameter,W] = AdaBoost(X,T)

lab= getlab(X);
n = size(X,1);
weight = rand(n,1);
beta = zeros(T,1);
hypo=zeros(T,n);
W = ones(n,T);
output1=zeros(T,n);
output2=output1;
for t=1:T
    p = weight/sum(weight);
    W(:,t) = p;
    [feature,theta,y,h] = weighted_weal_learner(X,p);
    parameter(t,:)=[feature,theta,y];
    hypo(t,:)=h;
    res=abs(h-lab);
    e=p'*res;
    beta(t)=e/(1-e);
    weight=weight.*(beta(t).^(1-res));
   % pre_sum 
    output1(t, :) = log(1/beta(t))*hypo(t,:);
    output2(t, :) = 0.5*log(1/beta(t));
end
h1 = sum(output1)';
h2 = sum(output2)';
preLab = h1 >= h2;
end

