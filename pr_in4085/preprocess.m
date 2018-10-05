function [obj] = preprocess(image_data)

fprintf('Resizing images \n');

obj = im_resize(image_data, [35 35]);
end