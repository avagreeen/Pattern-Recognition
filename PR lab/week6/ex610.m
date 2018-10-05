clear all;
X=rand(1000,2);
Y=rand(1000,2);
b=dataset(Y,Y(:,1)>.5&Y(:,2)>.5);
a=dataset(X,X(:,1)>.5&X(:,2)>.5);
%kernal=proxm('r',2);
model=svmtrain(double(a.Var2),a.X,'-t 2 -g 10 -b 1 -c 10 -q');
%scatterd(a.X);
%plotc(model);

[predict_label, accuracy, prob_values] = svmpredict(double(b.Var2), b.Y, model, '-b 1');