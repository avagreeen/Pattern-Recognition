

%%
%test on toy dataset
clear all
A = randn(100,2);
%randn('seed',1);
B = randn(100,2);
B(:,1) = B(:,1)+2;
X = [A;B];
lab = [ones(100,1);ones(100,1)-1];
X=prdataset(X,lab);
scatterd(X,'legend');
title(' original scatter plot')
hold on
[feat,theta,y] = weak_learner(X,lab);
%e = calculateError( feat,theta,y,X);
%fprintf('%f, %f, %f, %f ',feat, theta, y,err)

%% scale test

A1=[A(:,1)*10, A(:,2)];
B1=[B(:,1)*10, B(:,2)];
X1=[A1;B1];
X1=prdataset(X1,lab);
figure(2)
scatterd(X1,'legend');
title(' rescale feature 1')
[feat1,theta1,y1] = weak_learner(X1);
hold on
A1=[A(:,1), A(:,2)*10];
B1=[B(:,1), B(:,2)*10];
X1=[A1;B1];
X1=prdataset(X1,lab);
figure(3)
scatterd(X1,'legend');
title(' rescale feature 2')
[feat2,theta2,y2] = weak_learner(X1);
%% error is 18
%d
clear all
X=load('optdigitsubset.txt');

lab = [zeros(554,1);ones(571,1)];
X = prdataset(X,lab);
%[X,X_test] = gendat(X,[50,50]);
X_train = X([1:50,555:604],:);
X_test = X([51:554,605:end],:);

[feature,theta,y,err] = weak_learner(X_train);

e=cal_err(feature,theta,y,X_test)
%%  take random subset of 50
clear all
trails=200
X = load('optdigitsubset.txt');

lab = [zeros(554,1);ones(571,1)];
X = prdataset(X,lab);
Error = zeros(trails,1);
for i=1:trails
    [X_train,X_test] = gendat(X,[50,50]);
    [feat,theta,y] = weak_learner(X_train);
    e = cal_err(feat,theta,y,X_test);
    Error(i) = e;
end
 plot(Error,'rx');
title('Scatterplot of the testing errors');
xlabel('number of trials');
ylabel('testing error');
mean(Error)
std(Error)

%% e
clear all
trails=200
X = load('optdigitsubset.txt');
lab = [zeros(554,1);ones(571,1)];
X = prdataset(X,lab);
%%
clear all
A = randn(200,2);
B = randn(200,2);
B(:,1) = B(:,1)+2;
X = [A;B];
lab = [zeros(200,1);ones(200,1)];
X=prdataset(X,lab);

%%
avg_diss=zeros(100,1);
Error1=zeros(trails,1);Error2=zeros(trails,1);Error3=zeros(trails,1);
E1=zeros(trails,1);E2=zeros(trails,1);E3=zeros(trails,1);
for i=1:trails
    [X_train,X_test] = gendat(X,[50,50]);
    [feature1,theta1,y1,predict] = weak_learner(X_train);
    diss=abs(predict-getlab(X_train));
    e1 = cal_err(feature1,theta1,y1,X_test);
    Error1(i)=e1;
    %E1=
    %------------------
    weight=exp(-(diss));

    [feature2,theta2,y2,predict] = weighted_weal_learner(X_train,weight);
    e2 = cal_err(feature2,theta2,y2,X_test);
    Error2(i)=e2;
    %-----------------
    weight=exp((2*diss));

    [feature3,theta3,y3,predict] = weighted_weal_learner(X_train,weight);
    e3 = cal_err(feature3,theta3,y3,X_test);
    Error3(i)=e3;
    
end
%%
%true_label=getlab(X_train);
%diss=abs(avg_predict/100-true_label);

plot(Error2,'bp');
hold on
plot(Error3,'rp');
hold on
%%
plot(Error2-Error3,'rx');
%%
weight=exp(-(diss));

    [feature2,theta2,y2,min_score2,predict] = weighted_weal_learner(X_train,weight);
    e2 = cal_err(feature2,theta2,y2,X_test);
%% adaboost

clear all
X = load('optdigitsubset.txt');
lab = [zeros(554,1);ones(571,1)];
X = prdataset(X,lab);
T=10;

[predLab,para,l_weight]=AdaBoost(X,T);

error=sum(abs(predLab-lab))/size(X,1);
%% test on toydataset
clear all
B=gendatb([100,100]);
lab = [zeros(100,1);ones(100,1)];
B=pr_dataset(getdata(B),lab)

T=100;
[predLab,para,l_weight,W]=AdaBoost(B,T);
error=sum(abs(predLab-lab))/size(B,1);
l_weight=sum(W,2)
[b,i]=sort(l_weight);

index=i(end-10:end);
b=getdata(B);
figure(1)
scatterd(B,'o')
hold on 
plot(b(index,1),b(index,2),'g*')
%% final test

clear all
X=load('optdigitsubset.txt');

lab = [zeros(554,1);ones(571,1)];
X = prdataset(X,lab);
%[X,X_test] = gendat(X,[50,50]);
X_train = X([1:50,555:604],:);
X_test = X([51:554,605:end],:);
T=200;
[predLab,beta,para,l_weight,W]=AdaBoost(X_train,T);
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

%%
[b,i]=sort(err_tst);
index=i(1);
most_weight=W(:,index);
[b,i]=sort(most_weight);
index=i(end-9:end);

for i=1:9
  %  hight_weight=most_weight(index(i));
    img=+X_train(index(10-i),:);
    x=reshape(img,[8,8])
    subplot(3,3,i)
    s=image(x)
end
%%
