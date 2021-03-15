function reconstructed = my_idct2(coefficients)


[n,m] = size(coefficients);
reconstructed = zeros(n,m);

for i = 1:n
    row = coefficients(i,:);
    reconstructed(i,:) = my_idct(row);

end

for j = 1:m
    column = reconstructed(:,j);
    reconstructed(:,j) = my_idct(column);
end

