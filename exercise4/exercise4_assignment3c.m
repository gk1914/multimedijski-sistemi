A = imread('dog2.jpg');
A = rgb2gray(A);
[n,m] = size(A);

p1 = 0;
p2 = 0;
if mod(n,16)
    p1 = 16 - mod(n,16);
end
if mod(m,8)
    p2 = 16 - mod(m,16);
end
in = padarray(A,[p1,p2],'post');
[N,M] = size(in);


% -------- quality setting = 50% ---------------------------------------
Q = quantization_matrix(10);

out1 = zeros(N,M);
for i = 1:N/8
    for j = 1:M/8
        %dffdfg
        block = double(in(8*i-7:8*i, 8*j-7:8*j)) - 128;
        block = round(my_dct2(block)./Q);
        block = block.*Q;
        out1(8*i-7:8*i, 8*j-7:8*j) = block;
    end
end


% -------- quality setting = 50% ---------------------------------------
Q = quantization_matrix(50);

out2 = zeros(N,M);
for i = 1:N/8
    for j = 1:M/8
        %dffdfg
        block = double(in(8*i-7:8*i, 8*j-7:8*j)) - 128;
        block = round(my_dct2(block)./Q);
        block = block.*Q;
        out2(8*i-7:8*i, 8*j-7:8*j) = block;
    end
end


% -------- quality setting = 95% ---------------------------------------
Q = quantization_matrix(95);

out3 = zeros(N,M);
for i = 1:N/8
    for j = 1:M/8
        %dffdfg
        block = double(in(8*i-7:8*i, 8*j-7:8*j)) - 128;
        block = round(my_dct2(block)./Q);
        block = block.*Q;
        out3(8*i-7:8*i, 8*j-7:8*j) = block;
    end
end


%-------------------------- OUTPUT -------------------------------------
[a1,stat1] = norm2huff(uint8(out1(:)));
[a2,stat2] = norm2huff(uint8(out2(:)));
[a3,stat3] = norm2huff(uint8(out3(:)));
quality_setting = 0.10
stat1
quality_setting = 0.50
stat2
quality_setting = 0.95
stat3