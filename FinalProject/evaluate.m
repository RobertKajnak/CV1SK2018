function [MAP] = evaluate(d_or_s, sift_type, vocab_size, sample_size)
% Train SVM model
[car_model, airplane_model, face_model, motorbike_model] = ...
    classification_run(d_or_s, sift_type, vocab_size, sample_size);

% Rank images based on each model
models = {car_model, airplane_model, face_model, motorbike_model};
[car_images, airplane_images, face_images, motorbike_images] = ...
    test_SVM(d_or_s, sift_type, vocab_size, models);

% Save images for later use
mat_name = sprintf('%s%s%s%s%d%s%d%s', d_or_s, '-', sift_type, '-', vocab_size, '-', sample_size, '-');
% mat_name = d_or_s + '-' + sift_type + '-' + num2str(vocab_size) + '-';
save("image mats/" + mat_name + "car.mat", 'car_images');
save("image mats/" + mat_name + "aiplane.mat", 'airplane_images');
save("image mats/" + mat_name + "motorbike.mat", 'motorbike_images');
save("image mats/" + mat_name + "face.mat", 'face_images');


% Calculate Mean Average Precision
car_ap = average_precision(car_images, 'car');
plane_ap = average_precision(airplane_images, 'airplane');
face_ap = average_precision(face_images, 'face');
motor_ap = average_precision(motorbike_images, 'motorbike');
MAP = (car_ap + plane_ap + face_ap + motor_ap)/4;
disp(MAP);

end