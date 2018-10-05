function [ feature,theta,y,predict] = weighted_weal_learner(X,weight)

if nargin < 3
    lab = getlab(X);
end

weight = weight/sum(weight);
X = getdata(X);
[n,f] = size(X);
min_score=inf;
%feature=1;
%theta=0;
%y=1;
%predict=zeros(n,1);
for i = 1:f
    for j=1:n
        Theta=X(j,i);
        
        predict0=X(:,i)>=Theta;
        predict1=X(:,i)<=Theta;
        
        score0=sum(weight'*abs(predict0-lab));
        score1=sum(weight'*abs(predict1-lab));     
        
        score = min(score0,score1);
        
        if score<min_score
            min_score=score;
            y=sign(score0-score1); % if score0 larger, pred0 not good, y is <, y=1
            if score0>score1
                predict=predict1;
            else
                predict=predict0;
            end
            feature=i;
            theta = Theta;
    
        end
    end

end
end
