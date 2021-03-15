% load the images
imagefiles = dir('images/*.png');      
n = length(imagefiles);
for i = 1:n
   currentfilename = imagefiles(i).name;
   currentimage = imread(strcat('images/',currentfilename));
   images{i} = currentimage;
end



% load images - Caltech
%prepare_caltech('101_ObjectCategories', 5);
load list
img_list = list;
n = length(img_list)
    

% load reference image
ref = img_list{133};
ref_gray = rgb2gray(ref);
x = ref_gray(:);


% calculate Hellinger distance
dist = zeros(1, n);
for i = 1:n
    curr_gray = rgb2gray(img_list{i});
    y = curr_gray(:);
    NCC = (1/n) * (sum((x-mean(x)).*(y-mean(y))) / (sqrt((1/n)*sum((x-mean(x)).^2))*sqrt((1/n)*sum((y-mean(y)).^2))));
    dist(i) = NCC;
end
dist
[sorted idx] = sort(dist, 'descend')



% ---------------- OUTPUT: visualise top matches ---------------------
figure(2)
subplot(1,11,1), imshow(img_list{133})
subplot(1,11,2), imshow(img_list{idx(1)})
subplot(1,11,3), imshow(img_list{idx(2)})
subplot(1,11,4), imshow(img_list{idx(3)})
subplot(1,11,5), imshow(img_list{idx(4)})
subplot(1,11,6), imshow(img_list{idx(5)})
subplot(1,11,7), imshow(img_list{idx(6)})
subplot(1,11,8), imshow(img_list{idx(7)})
subplot(1,11,9), imshow(img_list{idx(8)})
subplot(1,11,10), imshow(img_list{idx(9)})
subplot(1,11,11), imshow(img_list{idx(10)})