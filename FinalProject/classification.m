function [model] = classification(d_or_s, sift_type, vocab_size, sample_size, pos_example)
cluster_file = "visual vocab mats/" + d_or_s + "-" + sift_type + "-" + vocab_size + ".mat";
clusters = load(cluster_file,'C');
clusters = clusters.C;
histograms = zeros(4*sample_size,vocab_size);

disp('cars');
% cars
car_files = dir(fullfile('Caltech4/ImageData/cars_train', '*.jpg'));
car_index = randperm(numel(car_files), sample_size);
for k = 1:sample_size
  image_file = fullfile('Caltech4/ImageData/cars_train', car_files(car_index(k)).name);
  image = imread(image_file);
  [~, image_descriptors] = sift(image, d_or_s, sift_type);
  image_descriptors = single(image_descriptors);
  Idx = knnsearch(clusters',image_descriptors');

  h = histogram(Idx, vocab_size, 'Normalization', 'Probability');
  histograms(k, :) = h.Values;
end

disp('planes');
% airplanes
airplane_files = dir(fullfile('Caltech4/ImageData/airplanes_train', '*.jpg'));
airplane_index = randperm(numel(airplane_files), sample_size);
for k = 1:sample_size
  image_file = fullfile('Caltech4/ImageData/airplanes_train', airplane_files(airplane_index(k)).name);
  image = imread(image_file);
  [~, image_descriptors] = sift(image, d_or_s, sift_type);
  image_descriptors = single(image_descriptors);
  Idx = knnsearch(clusters',image_descriptors');

  h = histogram(Idx, vocab_size, 'Normalization', 'Probability');
  histograms(sample_size+k, :) = h.Values; 
end

disp('faces');
% faces
faces_files = dir(fullfile('Caltech4/ImageData/faces_train', '*.jpg'));
faces_index = randperm(numel(faces_files), sample_size);
for k = 1:sample_size
  image_file = fullfile('Caltech4/ImageData/faces_train', faces_files(faces_index(k)).name);
  image = imread(image_file);
  [~, image_descriptors] = sift(image, d_or_s, sift_type);
  image_descriptors = single(image_descriptors);
  Idx = knnsearch(clusters',image_descriptors');

  h = histogram(Idx, vocab_size, 'Normalization', 'Probability');
  histograms(2*sample_size+k, :) = h.Values; 
end

disp('motorbikes');
% motorbikes
motor_files = dir(fullfile('Caltech4/ImageData/motorbikes_train', '*.jpg'));
motor_index = randperm(numel(motor_files), sample_size);
for k = 1:sample_size
  image_file = fullfile('Caltech4/ImageData/motorbikes_train', motor_files(motor_index(k)).name);
  image = imread(image_file);
  [~, image_descriptors] = sift(image, d_or_s, sift_type);
  image_descriptors = single(image_descriptors);
  if size(image_descriptors, 1) == 0 % gray image with a color sift_type
      % take image+1 instead
    image_file = fullfile('Caltech4/ImageData/motorbikes_train', motor_files(motor_index(k)+1).name);
    image = imread(image_file);
    [~, image_descriptors] = sift(image, d_or_s, sift_type);
    image_descriptors = single(image_descriptors);
  end
  Idx = knnsearch(clusters',image_descriptors');

  h = histogram(Idx, vocab_size, 'Normalization', 'Probability');
  histograms(3*sample_size+k, :) = h.Values; 
end

switch pos_example
    case 'car'
        labels = [1;-1;-1;-1];
    case 'airplane'
        labels = [-1;1;-1;-1];
    case 'face'
        labels = [-1;-1;1;-1];
    case 'motorbike'
        labels = [-1;-1;-1;1];
end
labels = repelem(labels,sample_size);

% used for SVM
histograms = sparse(histograms);
model = train(labels, histograms, '-c 100');
predict(labels, histograms, model);

disp('decision tree');
% used for decision trees
% model = fitctree(histograms, labels);
% [label,Posterior] = predict(model, histograms);
% assignin('base', 'tree_label', label);
% assignin('base', 'tree_decs', Posterior);

end

