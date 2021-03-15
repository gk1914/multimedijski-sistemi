A = imread('umbrellas.jpg');
Ad = double(A);

A_gray = uint8((Ad(:,:,1) + Ad(:,:,2) + Ad(:,:,3)) ./ 3);

figure(1);
imshow(A_gray);

% primerjava rezultata z built-in funkcijo 'rgb2gray'
%figure(2);
%imshow(rgb2gray(A))