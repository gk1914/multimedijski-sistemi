A = imread('umbrellas.jpg');
size(A)
A_gray = rgb2gray(A);
size(A_gray)
vector = reshape(A_gray, numel(A_gray), 1);
vector = double(vector);

H1 = hist(vector, 10);
H2 = hist(vector, 20);
H3 = hist(vector, 40);

figure(2);
subplot(1,3,1); bar(H1); axis square;
subplot(1,3,2); bar(H2); axis square;
subplot(1,3,3); bar(H3); axis square;
