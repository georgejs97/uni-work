function g = RatAppCat(N)
%RATAPPCAT The best rational approximation p/q of the 
%Catalan constant,among all pairs of (p,q) s.t. p+q <=N
trm = @(k) (-1)^k/(2*k +1).^2;
sum = 1;
counter = 1;
for u = 1:N
    for v = 1:(N-u)
        if (u/v == sum||v/u == sum)
            sum = sum + trm(counter);
            counter = counter+1;
            p = u;
            q = v;
        end
    end
end
g = [p,q];
return
end
