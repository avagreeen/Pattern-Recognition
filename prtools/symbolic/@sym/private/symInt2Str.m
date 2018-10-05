function s = symInt2Str(n)
% symInt2Str
% symInt2Str converts n into a character string.
% For real integers, the result is the same as for int2str.
% For complex integers a+b*I, symInt2Str does not drop the imaginary part
% n must be scalar

if isreal(n)
    s = int2str(n);
else
    s = [int2str(real(n)) '+' int2str(imag(n)) 'i'];
end
