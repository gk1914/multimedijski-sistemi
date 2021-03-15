% load the images
imagefiles = dir('images/*.png');      
n = length(imagefiles);
for i = 1:n
   currentfilename = imagefiles(i).name;
   currentimage = imread(strcat('images/',currentfilename));
   images{i} = currentimage;
end


test = images{5};
region_size = 32;
waitforbuttonpress

ref = images{5};
[h, w, c] = size(ref);

% padding
%{
p1 = 0;
p2 = 0;
if mod(h,40)
    p1 = 40 - mod(h,40);
end
if mod(w,40)
    p2 = 40 - mod(w,40);
end
if p1 > 0 || p2 > 0
    for i = 1:c
        extended(:,:,i) = padarray(ref(:,:,i),[p1,p2],'post');
    end
end
imshow(extended)
waitforbuttonpress
%}

%{
for i = 1:ceil(h/region_size)
    h1 = (i-1)*region_size + 1
    if i*region_size <= h
        h2 = i*region_size
    else
        h2 = h
    end
    for j = 1:ceil(w/region_size)
        w1 = (j-1)*region_size + 1
        if j*region_size <= w
            w2 = j*region_size
        else
            w2 = w
        end
        imshow(ref(h1:h2, w1:w2, :))
        waitforbuttonpress
    end
end
%}



% calculate histogram matrix for image database
H_matrix = [];
img_list = list;
for k = 1:n
    img = img_list{k};
    % calculate histograms for image subregions
    curr_hist = [];
    [h, w, c] = size(img);
    for i = 1:ceil(h/region_size)
        h1 = (i-1)*region_size + 1;
        if i*region_size <= h
            h2 = i*region_size;
        else
            h2 = h;
        end
        for j = 1:ceil(w/region_size)
            w1 = (j-1)*region_size + 1;
            if j*region_size <= w
                w2 = j*region_size;
            else
                w2 = w;
            end
            % reshape and combine histograms of subregions
            block = img(h1:h2, w1:w2, :);
            H = myhist3(block,8);
            [s1,s2,s3] = size(H);
            block_hist = [];
            for i = 1:s1
                transposed = H(:,:,i)';
                block_hist = [block_hist transposed(:)'];
            end
            curr_hist = [curr_hist block_hist];
            %H_matrix = [H_matrix; ch];
            %imshow(ref(h1:h2, w1:w2, :))
            %waitforbuttonpress
        end
    end
    % subregions - END
    size(curr_hist)
    H_matrix = [H_matrix; curr_hist];
    curr_hist = [];
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
    dist(i) = sqrt((1/2) * sum((sqrt(ref_hist) - sqrt(curr_hist)).^2));
end
dist
[sorted idx] = sort(dist)

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