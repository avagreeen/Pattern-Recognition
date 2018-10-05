%This function returns the classification error
function [testerror, trainerror] = test_classifier(test_feat, train_feat, model)
% global CHECK_SIZES;
% CHECK_SIZES = false;
testerror = testc(prdataset(test_feat), model);
trainerror = testc(prdataset(train_feat), model);
fprintf('Train Error');
disp(trainerror)
fprintf('\n Test Error');
disp(testerror)

fprintf('Model is Tested \n');
end