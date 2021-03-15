% load the images
imagefiles = dir('images/*.png');      
n = length(imagefiles);
for i = 1:n
   currentfilename = imagefiles(i).name;
   currentimage = imread(strcat('images/',currentfilename));
   images{i} = currentimage;
end

% load images - Caltech
%prepare_caltech('101_ObjectCategories', 10);
load list
img_list = list;
n = length(img_list)


% calculate histogram matrix for image database
H_matrix = [];
for i = 1:n
    img = img_list{i};
    H = myhist3(img,8);
    [s1,s2,s3] = size(H);
    %curr_hist = reshape(H, s1*s2*s3, 1);
    curr_hist = [];
    for i = 1:s1
        transposed = H(:,:,i)';
        curr_hist = [curr_hist transposed(:)'];
    end
    H_matrix = [H_matrix; curr_hist];
end
size(H_matrix)
    

% load reference image
ref = img_list{5};
imshow(ref)
ref_hist = H_matrix(5,:);


% calculate Hellinger distance
dist = zeros(1, n)
for i = 1:n
    curr_hist = H_matrix(i,:);
    dist(i) = 1 - sqrt((1/2) * sum((sqrt(ref_hist) - sqrt(curr_hist)).^2));
end
dist
[sorted idx] = sort(dist, 'descend')


% ---------------- OUTPUT: visualise top matches ---------------------
figure(1)
subplot(1,11,1), imshow(img_list{5})
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