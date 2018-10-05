%% final test

clear all
X=load('optdigitsubset.txt');

lab = [zeros(554,1);ones(571,1)];
X = prdataset(X,lab);
%[X,X_test] = gendat(X,[50,50]);
X_train = X([1:50,555:604],:);
X_test = X([51:554,605:end],:);
T=200;
[predLab,beta,para,W]=AdaBoost(X_train,T);
error=sum(abs(predLab-getlab(X_train)))/size(X_train,1);
% on test set
for t=1:T
    predLab_train=adaPredict(beta(1:t),para(1:t,:),X_train);
    true_lab=getlab(X_train);
    error_train = sum(abs(predLab_train-true_lab))/size(X_train,1);
    err_trn(t)=error_train;
    
    predLab_test=adaPredict(beta(1:t),para(1:t,:),X_test);
    true_lab=getlab(X_test);
    error_test = sum(abs(predLab_test-true_lab))/size(X_test,1);
    err_tst(t)=error_test;
end
plot(err_tst)
hold on 
plot(err_trn)
title('Classification error')
legend('test error','training error')