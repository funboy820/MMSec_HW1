function order=ZigzagOrder(dim)

order=zeros(dim);
len=dim*dim;

count=1;

for i=1:dim
    if (mod(i,2)==1)
        row=i;
        col=1;
        for j=0:i-1
            order(row-j, col+j)=count;
            count=count+1;
        end
    else
        row=1;
        col=i;
        for j=0:i-1
            order(row+j, col-j)=count;
            count=count+1;
        end
    end   
end

for i=(dim-1):-1:1
    if (mod(i,2)==1)
        row=dim;
        col=dim-i+1;
        for j=0:i-1
            order(row-j, col+j)=count;
            count=count+1;
        end
    else
        row=dim-i+1;
        col=dim;
        for j=0:i-1
            order(row+j, col-j)=count;
            count=count+1;
        end
    end   
end
