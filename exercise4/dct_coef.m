function [mat] = dct_coef(n)


mat = zeros(n,n);

for  i = 0:n-1
    for  j = 0:n-1
        if i == 0
            mat(i+1,j+1) = 1/sqrt(n);
        else
            mat(i+1,j+1) = sqrt(2/n)*cos((pi*((2*j)+1)*i)/(2*n));
        end
    end
end

