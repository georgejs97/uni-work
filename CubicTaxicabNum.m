function ctn = CubicTaxicabNum (N)
%CUBICTAXICABNUM return the smallest cubic taxicab 
%number greater than or equal to N
ctn = N;
bool = true;
while bool
    c=0;
    for i = 1:floor(ctn^(1/3))
        for j = 1:i-1
            if i^3 +j^3 == ctn
                c = c+1;
            end
            if c == 2
                return
            end
        end
    end
    c = 0;
    ctn = ctn +1;
end          
end