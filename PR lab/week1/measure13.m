obj_b=seldat(obj,13);
obj_b=obj_b*preproc;
figure(1);show(obj_b);
mean_set_b=im_mean(obj_b);
mean_data_b = double(mean_set_b);
scatterd(mean_data_b);