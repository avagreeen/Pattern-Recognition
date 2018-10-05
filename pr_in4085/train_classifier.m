function [model] = train_classifier(train_feat)

b = prdataset(train_feat);
model = bpxnc(b, [24 14]);

fprintf('Model is Trained \n');
end