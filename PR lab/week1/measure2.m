obj_a=seldat(obj,2);
obj_a=obj_a*preproc;
figure(2);show(obj_a);
mean_set_a=im_mean(obj_a);
mean_data_a = double(mean_set_a);
scatterd(mean_data_a);