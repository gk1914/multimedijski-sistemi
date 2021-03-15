% load CNN
vgg = load('vgg_final.mat');
n = length(vgg.list)

% load reference image
iref = 100;
ref = vgg.list{iref};
imshow(ref)
ref_features = vgg.features(iref,:);

% setup binary vector containing classifications for each images 
% (c(i) = 1 if classes(i) == ref_class;  else c(i) = 0)
ref_class = vgg.classes{iref}
c = zeros(1, n);
for i = 1:n
    c(i) = strcmp(vgg.classes{i}, ref_class);
end
waitforbuttonpress


% calculate Hellinger distance between feature vectors
dist = zeros(1, n);
for i = 1:n
    curr_features = vgg.features(i,:);
    dist(i) = 1 - sqrt((1/2) * sum((sqrt(ref_features) - sqrt(curr_features)).^2));
end
dist
[sorted, idx] = sort(dist, 'descend')



% ---------------- OUTPUT: calculate and draw ROC  -------------------
waitforbuttonpress
roc = get_roc(dist, c);
figure(5), plot(roc(:,1), roc(:,2))
waitforbuttonpress

% ----------------- OUTPUT: visualise top matches --------------------
figure(6)
subplot(2,5,1), imshow(vgg.list{idx(1)})
subplot(2,5,2), imshow(vgg.list{idx(2)})
subplot(2,5,3), imshow(vgg.list{idx(3)})
subplot(2,5,4), imshow(vgg.list{idx(4)})
subplot(2,5,5), imshow(vgg.list{idx(5)})
subplot(2,5,6), imshow(vgg.list{idx(6)})
subplot(2,5,7), imshow(vgg.list{idx(7)})
subplot(2,5,8), imshow(vgg.list{idx(8)})
subplot(2,5,9), imshow(vgg.list{idx(9)})
subplot(2,5,10), imshow(vgg.list{idx(10)})
