function y = softmax(x)
	y = bsxfun(@times, exp(x), sum(exp(x)).^(-1));
end
