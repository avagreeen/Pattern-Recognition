%------------------------------------------------------------------------
close all 
clear variables
clc
%global CHECK_SIZES 
%CHECK_SIZES = false;
%------------------------------------------------------------------------
% The execution process is as follows : 
% 1. Load data
% 2. Preprocess data
% 3. Feature Extraction
% 4. Split data
% 5. Train a Classifier
% 6. Test the Model
% ---------------------- LOAD DATA -------------------------------------- 
a = load_data();
%show(a(2))
processedObj = preprocess(a);

features = feature_extraction(processedObj);

[train_set, test_set, validation_set] = split_data(features, 0.5);

disp(size(train_set));
disp(size(test_set));
disp(size(validation_set));
%[features_train, features_test] = feature_extraction();

%model_name = 'nn';
classifierModel = train_classifier(train_set);
[cError, tError] = test_classifier(test_set, train_set, classifierModel);
