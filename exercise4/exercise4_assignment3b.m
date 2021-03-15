A = imread('dog2.jpg');
A = rgb2gray(A);
[n,m] = size(A);

% padding
p1 = 0;
p2 = 0;
if mod(n,16)
    p1 = 16 - mod(n,16);
end
if mod(m,8)
    p2 = 16 - mod(m,16);
end
in = padarray(A,[p1,p2],'post');


% quantization - quality setting
Q = quantization_matrix(10);

% --------------- JPEG compression ------------------------
[N,M] = size(in);
out = zeros(N,M);
quantized = zeros(N,M);
for i = 1:N/8
    for j = 1:M/8
        block = double(in(8*i-7:8*i, 8*j-7:8*j)) - 128;
        block = round(my_dct2(block)./Q);
        %block = my_idct2(block.*Q);
        block = block.*Q;
        quantized(8*i-7:8*i, 8*j-7:8*j) = block;
        block = my_idct2(block);
        block = round(block + 128);
        out(8*i-7:8*i, 8*j-7:8*j) = block;
    end
end

out = uint8(out);
quantized = uint8(quantized);

figure(1), imshow(A), title('original image')
figure(2), imshow(out), title('reconstructed image')
diff = imabsdiff(A,out);
figure(3), imshow(diff), title('difference')