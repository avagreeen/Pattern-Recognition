clear all;
im=imread('roadsign10.bmp');
show(im)

a=im2feat(im);
trainingset=gendat(a,500);
[d,w]=emclust(trainingset,nmc,4);  % get the classifier

lab=classim(a,w);  % get label image
figure(1)
imagesc(lab) %Display image with scaled colors

aa=prdataset(a,lab(:))  %creat laneled dataset
map=+meancov(aa)
figure(2)
colormap(map)      %set color map
%%
load triclust;
interactclust(a.data,'c',1)
%%
a=+gendats([50,50],2,10);

g=[1,2,3,5,10,20,40,50,100];
[P, LAB, WS]=kmclust(a,50,1,1);

errorbar


