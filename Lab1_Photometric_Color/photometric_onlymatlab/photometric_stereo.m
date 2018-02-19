close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = './photometrics_images/SphereGray5/';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map_row = construct_surface( p, q , 'row');
height_map_column = construct_surface(p, q, 'column');
height_map_average = construct_surface(p, q, 'average');
%% Display
show_results(albedo, normals, SE);
show_model(albedo, height_map_row);
show_model(albedo, height_map_column);
show_model(albedo, height_map_average);

%% monkey
%[image_stack, scriptV] = load_face_images('./photometrics_images/yaleB02/');
[image_stack, scriptV] = load_syn_images('./photometrics_images/MonkeyGray/');
image_stack = image_stack(:, :, 1:5:end);
scriptV = scriptV(1:5:end, :);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map_average = construct_surface( p, q, 'average' );
height_map_column = construct_surface(p, q, 'column');
height_map_row = construct_surface(p, q, 'row');

show_results(albedo, normals, SE);
show_model(albedo, height_map_column);


%% RGB
[image_stack1, scriptV1] = load_syn_images('./photometrics_images/SphereColor/', 1);
[image_stack2, scriptV2] = load_syn_images('./photometrics_images/SphereColor/', 2);
[image_stack3, scriptV3] = load_syn_images('./photometrics_images/SphereColor/', 3);
% [image_stack1, scriptV1] = load_syn_images('./photometrics_images/MonkeyColor/', 1);
% [image_stack2, scriptV2] = load_syn_images('./photometrics_images/MonkeyColor/', 2);
% [image_stack3, scriptV3] = load_syn_images('./photometrics_images/MonkeyColor/', 3);


[h, w, n] = size(image_stack1);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo1, normals1] = estimate_alb_nrm(image_stack1, scriptV1);
[albedo2, normals2] = estimate_alb_nrm(image_stack2, scriptV2);
[albedo3, normals3] = estimate_alb_nrm(image_stack3, scriptV3);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p1, q1, SE1] = check_integrability(normals1);
[p2, q2, SE2] = check_integrability(normals2);
[p3, q3, SE3] = check_integrability(normals3);

threshold = 0.005;
SE1(SE1 <= threshold) = NaN; % for good visualization
fprintf('Number of outliers channel 1: %d\n\n', sum(sum(SE1 > threshold)));
SE2(SE2 <= threshold) = NaN; % for good visualization
fprintf('Number of outliers channel 2: %d\n\n', sum(sum(SE2 > threshold)));
SE3(SE3 <= threshold) = NaN; % for good visualization
fprintf('Number of outliers channel 3: %d\n\n', sum(sum(SE3 > threshold)));

%% compute the surface height
height_map_average1 = construct_surface( p1, q1, 'average' );
height_map_average2 = construct_surface( p2, q2, 'average' );
height_map_average3 = construct_surface( p3, q3, 'average' );

show_results(albedo1, normals1, SE1);
show_model(albedo1, height_map_average1);

show_results(albedo2, normals2, SE2);
show_model(albedo2, height_map_average2);

show_results(albedo3, normals3, SE3);
show_model(albedo3, height_map_average3);

%% average the three rgb channels
image_stack_all = cat(4, image_stack1, image_stack3);
scriptV_all = cat(3, scriptV1, scriptV3);
image_stack = mean(image_stack_all, 4);
scriptV = mean(scriptV_all, 3);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map_average = construct_surface(p, q, 'average');
show_results(albedo, normals, SE);
show_model(albedo, height_map_average);

%% face
[image_stack, scriptV] = load_face_images('./photometrics_images/yaleB02/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map_average = construct_surface( p, q, 'average' );
height_map_column = construct_surface(p, q, 'column');
height_map_row = construct_surface(p, q, 'row');

show_results(albedo, normals, SE);
show_model(albedo, height_map_average);
show_model(albedo, height_map_row);
show_model(albedo, height_map_column);

