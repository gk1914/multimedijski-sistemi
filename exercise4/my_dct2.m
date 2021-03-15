function out = my_dct2(in)


[n,m] = size(in);
out = zeros(n,m);

for i = 1:n
    row = in(i,:);
    out(i,:) = my_dct(row);
end

for j = 1:m
    row = out(:,j);
    out(:,j) = my_dct(row);
end

end

