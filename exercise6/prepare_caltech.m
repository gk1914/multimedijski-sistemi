function prepare_caltech( path, n_samples )

% loads images from caltech_101 dataset and stores their classes
% uses n_samples images from each class
% only uses color images from each class
% resizes images to square for easier calculation

d=dir(path);
d(1:2) = [];

list = {};
classes = {};

n_classes = numel(d);
final_size = [100 100];

for i = 1:n_classes
    d(i).name
    if strcmp(d(i).name,'BACKGROUND_Google') % ignore class
        continue
    end
    images = dir(strcat(path,'/',d(i).name,'/*.jpg'));
    
    for j = 1:n_samples
        im = imread(strcat(path, '/',d(i).name,'/',images(j).name));
        if numel(size(im))==3
            im = imresize(im,final_size);
            list{end+1}=im;
            classes{end+1}=d(i).name;
        end
    end
end

save('list.mat','list');
save('classes.mat','classes');

end

