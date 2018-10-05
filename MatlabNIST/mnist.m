function mnist

%This is a short example program written for MATLAB that implements a simple multilayer
%feedforward network that learns solutions to the MNIST problem.
%Ian Gonthier, Mar 2017
%
%Network architecture:
%objective function: Olog(q)
%q=softmax(b)
%b=sigmoid(Vr)
%r=Softplus(Ws)
%W is of size r x s
%V is of size b x r
%r is of size r x n
%b is of size b x n
%q is of size b x n

%Gradient:
%DlnDV= (o-q).*l(1-l)*r'
%DlnDW=(((o-q).*l(1-l))'*V)'.*sig(Ws)*s'
 


%
%initialize weights
s = loadMNISTImages('./datas/mnistTrainImages');%load training data, then transpose
O = loadMNISTLabels('./datas/mnistTrainLabels')';%load training data labels, then transpose


sdims = size(s);
nrtrain = sdims(2);


sizeofs = sdims(1)
sizeofr = 200;%number of hidden units
sizeofb = 10;%our classification task covers 10 types of digits, 0-9

%load weights from file.
if exist('weightfile.mat', 'file'),
	load('weightfile.mat', 'W', 'V');	
else
	W = rand(sizeofr, sizeofs)*0.05;
	V = rand(sizeofb, sizeofr)*0.0001;
	disp('making a new weightfile');
	save('weightfile', 'W', 'V');
end

if size(W) ~= [sizeofr sizeofs],
	disp('Weights loaded are of an incorrect size. delete weightfile and try again.');
end


%number of gradient of descent steps we choose to use.
nrsteps = 60000;

%learning constant
gamma = 0.01;

%generate a one hot version of O
sizeo = size(O);
labls = zeros(10, sizeo(2));
size(labls)
for i = 1 : sizeo(2)
	labls(O(i)+1,i) = 1;
end;

dv = 0;
dw = 0;

%s
%basic gradient descent with no real stopping condition.
S = s;
o = labls;
nrtrain = 1;
for i = 1 : nrsteps,
	disp(i);

	s = S(:,i:(i+nrtrain-1));
	labls = o(:,i:(i+nrtrain-1));

	r = softplus(W*s);
	q = softmax(V*r);
	ln =(1/nrtrain)*sum(sum(-labls.*log(q)));
	fprintf('ln: %d\n', ln);

	DlnDV = -(labls-q)*r';
	DlnDW = (-(labls-q)'*V)'.*sigmoid(W*s)*s';

	%update weight vectors

	DlnDV = DlnDV/nrtrain;
	DlnDW = DlnDW/nrtrain;
	dv = 0.5*dv + gamma*DlnDV;
	dw = 0.5*dw + gamma*DlnDW;

	V = V - dv;
	W = W - dw; 
end;

%check training set performance
r = softplus(W*S);
b = sigmoid(V*r);	
q = softmax(b);

nrtrain = 60000;
[vals preds]= max(q);
trainAcc = (sum((preds-1) == O)/nrtrain)*100;

%check validation performance
s = loadMNISTImages('./datas/mnistValImages');%load validation data, then transpose
O = loadMNISTLabels('./datas/mnistValLabels')';%load validation data labels, then transpose
sizeofs = size(s)
nrVal = sizeofs(2)

r = softplus(W*s);
b = sigmoid(V*r);	
q = softmax(b);

[vals preds]= max(q);
valAcc = (sum((preds-1) == O)/nrVal)*100;

fprintf('Training accuracy: %d\n', trainAcc);
fprintf('Validation accuracy: %d\n', valAcc);


%now I only have to write these once
end
