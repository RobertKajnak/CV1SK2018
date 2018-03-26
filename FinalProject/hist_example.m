% Example of hist (needs to be extended to a function)

image = imread('Caltech4/ImageData/airplanes_train/img455.jpg');
clusters = load('visual vocab mats/sift-gray.mat','C');
clusters = clusters.C;

[~, image_descriptors] = sift(image, 'sift', 'gray');

Idx = knnsearch(clusters',image_descriptors');

histogram(Idx, 400);