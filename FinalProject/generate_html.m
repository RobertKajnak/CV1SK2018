function generate_html(filename)

html_file = fileread('Template_Result.html');

% replace names
html_file = strrep(html_file, 'stu1_name, stu2_name', 'Manon Schriever, Robert Kajnak');
% filename into strings
properties = strsplit(filename,'-');
d_or_s = string(properties(1));
sift_type = string(properties(2));
vocab_size = string(properties(3));
sample_size = string(properties(4));

%% write settings

% step & block size
if strcmp(d_or_s, "dsift")
    html_file = strrep(html_file, "SIFT step size</th><td>XXX px", "SIFT step size</th><td> 20 px");  
    html_file = strrep(html_file, "SIFT block sizes</th><td>XXX pixels", "SIFT block sizes</th><td>3 pixels");
else % sift has no step & block size
    html_file = erase(html_file, "<tr><th>SIFT step size</th><td>XXX px</td></tr>");
    html_file = erase(html_file, "<tr><th>SIFT block sizes</th><td>XXX pixels</td></tr>");
end

% sift method
html_file = strrep(html_file, "<tr><th>SIFT method</th><td>XXX-SIFT</td></tr>", ...
    "<tr><th>SIFT method</th><td>" + sift_type + '-' + d_or_s + "</td></tr>");

% vocabulary size
html_file = strrep(html_file, "Vocabulary size</th><td>XXX words", ...
    "Vocabulary size</th><td>"+ vocab_size + " words");

% vocabulary fraction
html_file = strrep(html_file, "Vocabulary fraction</th><td>XXX", ...
    "Fraction used for visual vocabulary</th><td>1/2");

% SVM data
html_file = strrep(html_file, "SVM training data</th><td>XXX positive, XXX negative per class", ...
    "SVM training data</th><td>"+ sample_size + " positive, " + string(3*str2double(sample_size)) + " negative per class");

% Used liblinear so no specify that instead of kernel
html_file = strrep(html_file, "<tr><th>SVM kernel type</th><td>XXX</td></tr>", ...
    "<tr><th>SVM type</th><td>Standard liblinear with cost=100</td></tr>");

%% get images and (m)ap scores
airplane = load("image mats/"+filename+"-aiplane.mat");
airplane = airplane.airplane_images;
car = load("image mats/"+filename+"-car.mat");
car = car.car_images;
face = load("image mats/"+filename+"-face.mat");
face = face.face_images;
motorbike = load("image mats/"+filename+"-motorbike.mat");
motorbike = motorbike.motorbike_images;

plane_ap = average_precision(airplane, 'airplane');
car_ap = average_precision(car, 'car');
face_ap = average_precision(face, 'face');
motor_ap = average_precision(motorbike, 'motorbike');

map = (plane_ap + car_ap + face_ap + motor_ap)/4;

% write ap and map to file
html_file = strrep(html_file, "(MAP: 0.XXX)", "(MAP:" + map + ")");
html_file = strrep(html_file, "Airplanes (AP: 0.XXX)", "Airplanes (AP: "+ plane_ap+")");
html_file = strrep(html_file, "Cars (AP: 0.XXX)", "Cars (AP: "+ car_ap+")");
html_file = strrep(html_file, "Faces (AP: 0.XXX)", "Faces (AP: "+ face_ap+")");
html_file = strrep(html_file, "Motorbikes (AP: 0.XXX)", "Motorbikes (AP: "+ motor_ap+")");

%% write images to file
full_image_chars = '';
for i = 1:200
    plane_i = airplane{i,1};
    car_i = car{i,1};
    face_i = face{i,1};
    motor_i = motorbike{i,1};
    % search each folder for each image
    test_files = dir('Caltech4/ImageData/*_test/*.jpg');
    foundnum = 0;
    for j = 1:length(test_files)
        image = imread(fullfile(test_files(j).folder, test_files(j).name));
        if isequal(image, plane_i)
            plane_file = fullfile(test_files(j).folder, test_files(j).name);
            foundnum = foundnum + 1;
        end
        if isequal(image, car_i)
            car_file = fullfile(test_files(j).folder, test_files(j).name);
            foundnum = foundnum + 1;
        end
        if isequal(image, face_i)
            face_file = fullfile(test_files(j).folder, test_files(j).name);
            foundnum = foundnum + 1;
        end
        if isequal(image, motor_i)
            motor_file = fullfile(test_files(j).folder, test_files(j).name);
            foundnum = foundnum + 1;
        end
        if foundnum == 4 % all images found
            break
        end
    end
    % html needs relative path
    plane_file = erase(plane_file, pwd + "/");
    car_file = erase(car_file, pwd + "/");
    face_file = erase(face_file, pwd + "/");
    motor_file = erase(motor_file, pwd + "/");
    full_image_chars = strcat(full_image_chars, ...
        '<tr><td><img src="', plane_file , ...
        '" /></td><td><img src="' , car_file , ...
        '" /></td><td><img src="', face_file , ...
        '" /></td><td><img src="', motor_file , '" /></td></tr>');
end
% remove first 6 image lines of templae
html_file = erase(html_file, '<tr><td><img src="Caltech4/ImageData/airplanes_test/img003.jpg" /></td><td><img src="Caltech4/ImageData/cars_test/img024.jpg" /></td><td><img src="Caltech4/ImageData/faces_test/img015.jpg" /></td><td><img src="Caltech4/ImageData/motorbikes_test/img001.jpg" /></td></tr>');
html_file = erase(html_file, '<tr><td><img src="Caltech4/ImageData/airplanes_test/img020.jpg" /></td><td><img src="Caltech4/ImageData/cars_test/img037.jpg" /></td><td><img src="Caltech4/ImageData/faces_test/img013.jpg" /></td><td><img src="Caltech4/ImageData/motorbikes_test/img007.jpg" /></td></tr>');
html_file = erase(html_file, '<tr><td><img src="Caltech4/ImageData/airplanes_test/img010.jpg" /></td><td><img src="Caltech4/ImageData/cars_test/img046.jpg" /></td><td><img src="Caltech4/ImageData/faces_test/img008.jpg" /></td><td><img src="Caltech4/ImageData/motorbikes_test/img039.jpg" /></td></tr>');
html_file = erase(html_file, '<tr><td><img src="Caltech4/ImageData/airplanes_test/img035.jpg" /></td><td><img src="Caltech4/ImageData/cars_test/img014.jpg" /></td><td><img src="Caltech4/ImageData/faces_test/img044.jpg" /></td><td><img src="Caltech4/ImageData/motorbikes_test/img008.jpg" /></td></tr>');
html_file = erase(html_file, '<tr><td><img src="Caltech4/ImageData/airplanes_test/img049.jpg" /></td><td><img src="Caltech4/ImageData/cars_test/img039.jpg" /></td><td><img src="Caltech4/ImageData/faces_test/img018.jpg" /></td><td><img src="Caltech4/ImageData/motorbikes_test/img044.jpg" /></td></tr>');
html_file = erase(html_file, '<tr><td><img src="Caltech4/ImageData/airplanes_test/img025.jpg" /></td><td><img src="Caltech4/ImageData/cars_test/img023.jpg" /></td><td><img src="Caltech4/ImageData/faces_test/img050.jpg" /></td><td><img src="Caltech4/ImageData/motorbikes_test/img048.jpg" /></td></tr>');
% replace last line with correct images
html_file = strrep(html_file, '<tr><td><img src="Caltech4/ImageData/airplanes_test/img013.jpg" /></td><td><img src="Caltech4/ImageData/cars_test/img035.jpg" /></td><td><img src="Caltech4/ImageData/faces_test/img037.jpg" /></td><td><img src="Caltech4/ImageData/motorbikes_test/img021.jpg" /></td></tr>',...
    full_image_chars);

%%  save file
fid = fopen(filename + ".html",'w');
fprintf(fid, '%s', html_file);
fclose(fid);
end