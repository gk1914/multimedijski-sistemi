function reconstructed = my_idct(coefficients)

n = length(coefficients);

reconstructed = zeros(1,n);
X0 = coefficients(1)/n;
for i = 1:n
    x = X0;
    for j = 2:n
        %dkjdjfj
        x = x + (2/n)*coefficients(j)*cos((pi/n)*(j-1)*((i-1)+0.5));
    end
    reconstructed(i) = x;
end

%reconstructed