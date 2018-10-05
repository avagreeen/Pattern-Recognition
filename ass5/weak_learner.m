function [ feature,theta,y,min_score,predict] = weak_learner(X,lab)

if nargin < 2
    lab = getlab(X);
end


X = getdata(X);
[n,f] = size(X);
min_score=inf;
for i = 1:f
    for j=1:n
        Theta=X(j,i);
        
        predict0=X(:,i)>=Theta;
        predict1=X(:,i)<=Theta;
        
        score0=sum((predict0-lab).^2)/n;
        score1=sum((predict1-lab).^2)/n;     
        
        score = min(score0,score1);
        
        if score<min_score
            min_score=score;
            y=sign(score0-score1); % if 0, y is <, if 1. y is >
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