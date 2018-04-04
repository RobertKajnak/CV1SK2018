function [car_model, airplane_model, face_model, motorbike_model] = ...
    classification_run(d_or_s, sift_type, vocab_size, sample_size)
disp('train car model');
car_model = classification(d_or_s, sift_type, vocab_size, sample_size, 'car');
disp('train airplane model');
airplane_model = classification(d_or_s, sift_type, vocab_size, sample_size, 'airplane');
disp('train face model');
face_model = classification(d_or_s, sift_type, vocab_size, sample_size, 'face');
disp('train motorbike model');
motorbike_model = classification(d_or_s, sift_type, vocab_size, sample_size, 'motorbike');
end