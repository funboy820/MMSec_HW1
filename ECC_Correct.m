function [trueData] = ECC_Correct(data)

setLen = 3;
n = length(data);
trueData = data;

% Turn -1 to 0
for i=1:n
    if trueData(i) == -1
        trueData(i) = 0;
    end
end

% Start correcting
numSet = floor(n / setLen);
for i=1:numSet
    sHead = (i-1)*setLen+1;
    sTail = i*setLen;
    
    d = trueData(sHead:sTail);
    
    p1 = ECC_GetEvenParity(d, 1);
    p2 = ECC_GetEvenParity(d, 2);
%     p4 = ECC_GetEvenParity(d, 4);
%     p8 = ECC_GetEvenParity(d, 8);
    
%     pos = p1*1 + p2*2 + p4*4 + p8*8;
    pos = p1*1 + p2*2;
    
    if pos ~= 0
        d(pos) = mod(d(pos)+1, 2);
        trueData(sHead:sTail) = d;
    end
        
end

% Turn 0 to -1
for i=1:n
    if trueData(i) == 0;
        trueData(i) = -1;
    end
end

end

