function [idx,C] = bow_build_vocab(d_or_s, sift_type)
    airplanes = dir('Caltech4/ImageData/airplanes_train/*.jpg');
    cars = dir('Caltech4/ImageData/cars_train/*.jpg');
    faces = dir('Caltech4/ImageData/faces_train/*.jpg');
    motorbikes = dir('Caltech4/ImageData/motorbikes_train/*.jpg');
    
    all_descriptors = [];
    
    for data_cell = {airplanes cars faces motorbikes}
        data = data_cell{:};
        for i=1:3%floor((length(data)/2)
            file = fullfile(data(i).folder, data(i).name);
            image = imread(file);
            [~, descriptors] = sift(image, d_or_s, sift_type);
            all_descriptors = [all_descriptors; descriptors'];
            
        end
    end
    all_descriptors = double(all_descriptors);
    [idx,C] = kmeans(all_descriptors, 400, 'Display', 'iter');
end