function [car_images, airplane_images, face_images, motorbike_images, motor_labels, motorbike_decs] = ...
    test_SVM(d_or_s, sift_type, vocab_size, models)

car_model = models{1};
airplane_model = models{2};
face_model = models{3};
motorbike_model = models{4};
% testing
% vocab_size = 400;
% d_or_s = 'sift';
% sift_type = 'gray';
cluster_file = "visual vocab mats/" + d_or_s + "-" + sift_type + "-" + vocab_size + ".mat";
clusters = load(cluster_file,'C');
clusters = clusters.C;
%histograms = zeros(200,vocab_size);
all_images = {};

% cars
car_hist = zeros(50, vocab_size);
car_files = dir(fullfile('Caltech4/ImageData/cars_test', '*.jpg'));
for k = 1:50
  image_file = fullfile('Caltech4/ImageData/cars_test', car_files(k).name);
  image = imread(image_file);
  all_images{k, 1} = image;
  all_images{k, 2} = 'car';
  [~, image_descriptors] = sift(image, d_or_s, sift_type);
  image_descriptors = single(image_descriptors);
  Idx = knnsearch(clusters',image_descriptors');

  h = histogram(Idx, vocab_size, 'Normalization', 'Probability');
  car_hist(k, :) = h.Values;
end

% airplanes
airplane_files = dir(fullfile('Caltech4/ImageData/airplanes_test', '*.jpg'));
airplane_hist = zeros(50, vocab_size);
for k = 1:50
  image_file = fullfile('Caltech4/ImageData/airplanes_test', airplane_files(k).name);
  image = imread(image_file);
  all_images{50+k, 1} = image;
  all_images{50+k, 2} = 'airplane';
  [~, image_descriptors] = sift(image, d_or_s, sift_type);
  image_descriptors = single(image_descriptors);
  Idx = knnsearch(clusters',image_descriptors');

  h = histogram(Idx, vocab_size, 'Normalization', 'Probability');
  airplane_hist(k, :) = h.Values; 
end

% faces
face_hist = zeros(50, vocab_size);
faces_files = dir(fullfile('Caltech4/ImageData/faces_test', '*.jpg'));
for k = 1:50
  image_file = fullfile('Caltech4/ImageData/faces_test', faces_files(k).name);
  image = imread(image_file);
  all_images{100+k, 1} = image;
  all_images{100+k, 2} = 'face';

  [~, image_descriptors] = sift(image, d_or_s, sift_type);
  image_descriptors = single(image_descriptors);
  Idx = knnsearch(clusters',image_descriptors');

  h = histogram(Idx, vocab_size, 'Normalization', 'Probability');
  face_hist(k, :) = h.Values; 
end

% motorbikes
motor_hist = zeros(50, vocab_size);
motor_files = dir(fullfile('Caltech4/ImageData/motorbikes_test', '*.jpg'));
for k = 1:50
  image_file = fullfile('Caltech4/ImageData/motorbikes_test', motor_files(k).name);
  image = imread(image_file);
  all_images{150+k, 1} = image;
  all_images{150+k, 2} = 'motorbike';
  [~, image_descriptors] = sift(image, d_or_s, sift_type);
  image_descriptors = single(image_descriptors);
  Idx = knnsearch(clusters',image_descriptors');

  h = histogram(Idx, vocab_size, 'Normalization', 'Probability');
  motor_hist(k, :) = h.Values; 
end

% Predict
histograms = [car_hist; airplane_hist; face_hist; motor_hist];

labels = repelem([1;-1;-1;-1], 50);
[~, ~, car_decs] = predict(labels, sparse(histograms), car_model);
labels = repelem([-1;1;-1;-1], 50);
[~, ~, airplane_decs] = predict(labels, sparse(histograms), airplane_model);
labels = repelem([-1;-1;1;-1], 50);
[~, ~, face_decs] = predict(labels, sparse(histograms), face_model);
labels = repelem([-1;-1;-1;1], 50);
[motor_labels, ~, motorbike_decs] = predict(labels, sparse(histograms), motorbike_model);

[~, car_sort] = sort(car_decs, 'descend');
car_images = all_images(car_sort, :);

[~, airplane_sort] = sort(airplane_decs, 'descend');
airplane_images = all_images(airplane_sort, :);

[~, face_sort] = sort(face_decs, 'descend');
face_images = all_images(face_sort, :);

[bike_sorted, motorbike_sort] = sort(motorbike_decs, 'descend');
motorbike_images = all_images(motorbike_sort, :);


end
