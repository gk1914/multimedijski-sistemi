% load images - Caltech
%prepare_caltech('101_ObjectCategories', 5);
load list
load classes
img_list = list;
class_list = classes;
n = length(img_list)

% load CNN
vgg = load('vgg_final.mat');
nCNN = length(vgg.list)
waitforbuttonpress
r = randperm(2500, 500);
vgglist = cell(500,1);
vggclasses = cell(500,1);
vggfeatures = zeros(500, length(vgg.features(1,:)));
for i = 1:length(r)
    %sjdfhjsdf
    idx = r(i)
    vgglist{idx} = vgg.list{idx};
    vggclasses{idx} = vgg.classes{idx};
    vggfeatures(idx,:) = vgg.features(idx,:);
end


scores1 = []
groundtruth1 = []
scores2 = []
scores3 = []
groundtruth3 = []

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



% select each image as the reference image
for i = 1:n
    ref = img_list{i};
    ref_class = class_list{i};
    ref_hist = H_matrix(i,:);
    dist1 = [];
    bin_class1 = [];
    dist2 = [];
    bin_class2 = [];
    dist3 = [];
    bin_class3 = [];
    % calculate distance to all other images
    for j = 1:n
        if i == j
            break
        end
        curr = img_list{j};
        curr_class = class_list{j};
        % histogram Hellinger distance
        curr_hist = H_matrix(j,:);
        dist1 = [dist1 (1 - sqrt((1/2) * sum((sqrt(ref_hist) - sqrt(curr_hist)).^2)))];
        bin_class1 = [bin_class1 strcmp(ref_class, curr_class)];

        
        % NCC
        curr_gray = rgb2gray(curr);
        y = curr_gray(:);
        NCC = (1/n) * (sum((x-mean(x)).*(y-mean(y))) / (sqrt((1/n)*sum((x-mean(x)).^2))*sqrt((1/n)*sum((y-mean(y)).^2))));
        dist2 = [dist2 NCC];
    end
    scores1 = [scores1 dist1];
    groundtruth1 = [groundtruth1 bin_class1];
    scores2 = [scores2 dist2];
end



% select each image as the reference image
for i = 1:500
    i
    ref = vgglist{i};
    ref_class = vggclasses{i};
    ref_features = vggfeatures(i,:);
    dist3 = [];
    bin_class3 = [];
    % calculate distance to all other images
    for j = 1:nCNN
        if i == j
            break
        end
        curr = vgg.list{j};
        curr_class = vgg.classes{j};
        curr_features = vgg.features(j,:);
        dist3 = [dist3 (1 - sqrt((1/2) * sum((sqrt(ref_features) - sqrt(curr_features)).^2)))];
        bin_class3 = [bin_class3 strcmp(ref_class, curr_class)];
    end
    scores3 = [scores3 dist3];
    groundtruth3 = [groundtruth3 bin_class3];
end



% ---------------- OUTPUT: calculate and draw ROC  -------------------
%waitforbuttonpress
[roc1, AUC1, closest1, thr1, F1]  = get_roc(scores1, groundtruth1);
figure(2), plot(roc1(:,1), roc1(:,2)), title(sprintf('Hist. Hellinger dist.: t = %1.3g, F = %1.3g, AUC = %1.3g', thr1, F1, AUC1))
[roc2, AUC2, closest2, thr2, F2]  = get_roc(scores2, groundtruth1);
figure(3), plot(roc2(:,1), roc2(:,2)), title(sprintf('NCC: t = %1.3g, F = %1.3g, AUC = %1.3g', thr2, F2, AUC2))
[roc3, AUC3, closest3, thr3, F3] = get_roc(scores3, groundtruth3);
figure(4), plot(roc3(:,1), roc3(:,2)), title(sprintf('CNN: t = %1.3g, F = %1.3g, AUC = %1.3g', thr3, F3, AUC3))
