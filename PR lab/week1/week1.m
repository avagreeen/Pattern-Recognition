delfigs
obj1 = kimia_images
obj1 = seldat(obj1,[3:3:18]);
figure(1); show(obj1);
obj2 = im_box(obj1,0,1);
figure(2); show(obj2);
obj3 = im_rotate(obj2);
figure(3); show(obj3);
obj4 = im_resize(obj3,[20 20]);
figure(4); show(obj4);
obj5 = im_box(obj4,1,0);
figure(5); show(obj5);
showfigs
