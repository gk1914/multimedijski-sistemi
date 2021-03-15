A = imread('trucks.jpg');
A_hsv = rgb2hsv(A);
hue = A_hsv(:,:,1);
[h, w, d] = size(A)

% masking & thresholding the blue channel of the org RGB image
mask = A(:,:,3) > 200;
thresholded = isolate_color(A, mask);

% show result - RGB image
figure(1);
subplot(1,2,1);
imshow(A);
subplot(1,2,2);
imshow(thresholded);


%visualize HSV color spectrum
I = ones(20, 255, 3);
I(:,:,1) = ones(20, 1) * linspace(0, 1, 255);
figure(2);
image([0,1], [0,1], hsv2rgb(I));

% masking & thresholding - HSV
min = 0.5;
max = 0.75;
mask1 = zeros(size(h, w));
mask2 = zeros(size(h, w));
for i = 1:h
    for j = 1:w
        mask1(i,j) = hue(i,j) > min;
        mask2(i,j) = hue(i,j) < max;
    end
end
thresholded = isolate_color(A, mask1 & mask2);

% show result - HSV image
figure(3);
imshow(thresholded);