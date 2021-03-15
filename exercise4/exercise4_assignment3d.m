A = imread('dog2.jpg');
A = rgb2ycbcr(A);

subsampling = 16;
y = A(:,:,1);
cb = A(:,:,2)/subsampling;
cr = A(:,:,3)/subsampling;

Q = quantization_matrix(10);

in = y;
[N,M] = size(in);
out1 = zeros(N,M);
quantized1 = zeros(N,M);
for i = 1:N/8
    for j = 1:M/8
        block = double(in(8*i-7:8*i, 8*j-7:8*j)) - 128;
        block = round(my_dct2(block)./Q);
        %block = my_idct2(block.*Q);
        block = block.*Q;
        quantized1(8*i-7:8*i, 8*j-7:8*j) = block;
        block = my_idct2(block);
        block = round(block + 128);
        out1(8*i-7:8*i, 8*j-7:8*j) = block;
    end
end
out1 = uint8(out1);

in = cb;
[N,M] = size(in);
out2 = zeros(N,M);
quantized2 = zeros(N,M);
for i = 1:N/8
    for j = 1:M/8
        block = double(in(8*i-7:8*i, 8*j-7:8*j)) - 128;
        block = round(my_dct2(block)./Q);
        %block = my_idct2(block.*Q);
        block = block.*Q;
        quantized2(8*i-7:8*i, 8*j-7:8*j) = block;
        block = my_idct2(block);
        block = round(block + 128);
        out2(8*i-7:8*i, 8*j-7:8*j) = block;
    end
end
out2 = uint8(out2);

in = cr;
[N,M] = size(in);
out3 = zeros(N,M);
quantized3 = zeros(N,M);
for i = 1:N/8
    for j = 1:M/8
        block = double(in(8*i-7:8*i, 8*j-7:8*j)) - 128;
        block = round(my_dct2(block)./Q);
        %block = my_idct2(block.*Q);
        block = block.*Q;
        quantized3(8*i-7:8*i, 8*j-7:8*j) = block;
        block = my_idct2(block);
        block = round(block + 128);
        out3(8*i-7:8*i, 8*j-7:8*j) = block;
    end
end
out3 = uint8(out3);


% ------------ combine channels and convert back to rgb --------------
out = cat(3, out1, out2*subsampling, out3*subsampling);
quantized = uint8(cat(3, quantized1, quantized2, quantized3));
out = ycbcr2rgb(out);