function sum = sumPF()
%SUMPF find an approximation of the sum of reciprocal
%squares with prime factors
N = 100000;
trm = @(k) (-1).^(length(factor(k)))/k.^2;
sum = 1;
counter = 2;
while counter < N
    sum = sum + trm(counter);
    counter = counter +1;
end
end