function [train_set, test_set, validation_set] = split_data(data, sizeOfTrainSet)

% If split is to be done as 50-50% 
[train_set, test_set] = gendat(data, sizeOfTrainSet);

validation_set = gendat(test_set, 0.4);

fprintf('Training & Test set have been generated \n');
end