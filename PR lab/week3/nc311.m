n=10;
for i = 1:10
a = laplace(n,1);
h(i,:) = hist(+a,-5:5);
end;
errorbar (-5:5, mean(h), std(h));
