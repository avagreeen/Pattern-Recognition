%% Ex9.1
clear all;
load hall;

scatterd(a);
oc=interactclust(a.data,'c')


%% Ex9.2
clear all;
close all;

load rnd;

interactclust(+a,'s');
%% 
clear all;
load messy;
scatterd(a);

interactclust(a.data,'s');
%%
clear all;

load rnd;

[P, lab, WS]=kmclust(a,3,1,2);
%data=prdataset(P,lab);
%scatterd(data);
