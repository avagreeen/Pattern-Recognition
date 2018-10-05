function [features] = feature_extraction(procData)

% feat1 = im_stat([],'sum');
% feat2 = filtim('bwperim')*im_stat([],'sum');
% 
% for i = length(procData)
%     features = procData*[feat1 feat2]*datasetm;
% end
% features_dat = datasetm(double(features));
% features_new = setfeatlab(features_dat, {'Size', 'Perimeter'});
% disp(double(features_new))
% fprintf('Extracted Features \n');

feat1 = im_moments([], 'hu');
features = prdataset(procData*feat1);

end