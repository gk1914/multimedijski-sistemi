A = imread('umbrellas.jpg');
A_gray = rgb2gray(A);
A_gray = double(A_gray);

% org version
figure(1);
imshow(uint8(A_gray));

% reduction
reduction_factor = 1/4;
A_gray = A_gray * reduction_factor;
A_gray = uint8(A_gray);

% imshow - grayscale reduced version
figure(2);
imshow(A_gray);

% imagesc - grayscale reduced version
figure(3);
colormap gray;
imagesc(A_gray);
axis tight; axis equal;