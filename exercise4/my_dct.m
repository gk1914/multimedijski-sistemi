function coeficients = my_dct(signal)

n = length(signal);
coeficients = zeros(1, n);
for i = 1:n
    X = 0;
    for j = 1:n
        %dfkfk
        X = X + signal(j)*cos((pi/n)*((j-1)+0.5)*(i-1));
    end
    coeficients(i) = X;
end

%coeficients