function [parity] = ECC_GetEvenParity(segment, pos)

len = length(segment);

cnt = 0;
i=pos;
while i<=len
    for j=1:pos
        cnt = cnt + segment(i+j-1);
    end
    
    i = i + pos*2;
end

parity = mod(cnt, 2);

end

