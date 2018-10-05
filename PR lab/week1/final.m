d=[mean_data_a;mean_data_b];
lable_a=repmat(['1'],12,1)
lable_b=repmat(['0'],12,1)
lable=[lable_a;lable_b]
d=prdataset(d,lable)
figure(3);scatterd(d)