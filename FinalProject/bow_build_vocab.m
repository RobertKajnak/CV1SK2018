function [C, A] = bow_build_vocab(d_or_s, sift_type, vocab_size)

    if nargin == 2
        vocab_size = 400;
    end
    
    airplanes = dir('Caltech4/ImageData/airplanes_train/*.jpg');
    cars = dir('Caltech4/ImageData/cars_train/*.jpg');
    faces = dir('Caltech4/ImageData/faces_train/*.jpg');
    motorbikes = dir('Caltech4/ImageData/motorbikes_train/*.jpg');
    
    all_descriptors = [];
    
    for data_cell = {airplanes cars faces motorbikes}
        data = data_cell{:};
        for i=1:floor((length(data)/2))
            file = fullfile(data(i).folder, data(i).name);
            image = imread(file);
            [~, descriptors] = sift(image, d_or_s, sift_type);
%             % Take subset of data for dsift
%             if strcmpi(d_or_s, 'dsift') && size(descriptors, 2) > 1000
%                 descriptors = datasample(descriptors, 1000, 2, 'Replace', false);
%             end
            all_descriptors = [all_descriptors descriptors];
            
        end
    end
    all_descriptors = single(all_descriptors);
    disp(size(all_descriptors));
    tic
    [C, A] = vl_kmeans(all_descriptors, vocab_size, 'Verbose', 'Initialization', 'plusplus', ...
             'Algorithm', 'elkan', 'maxnumiterations', 500, 'numrepetitions', 2);
    toc
end
