clear all;
close all;

%% load files
ball = imread('ball.png');
ball_r = imread('ball_reflectance.png');
ball_s = imread('ball_shading.png');


%% Find out true color

%the image is converted to have the color as a contiguous unit
true_color_single = triple2single(ball_r);
%the unique color are selected
true_color = unique(true_color_single);
%black is used as the background, so that is cut
true_color = true_color(true_color>0);
%the color is converted back to the 3byte structure
true_color = single2triple(true_color,1);
disp('Colors present in the picture in RGB (excluding black):');
disp(true_color)

%% perform recoloring

green_image = recolor(ball_r,ball_s,'ff00');
magenta_image = recolor(ball_r,ball_s,'ff00ff');

%% plot
figure('name','Ball and modified colors');

subplot(1,3,1);
imshow(ball);
title('Original Image');

subplot(1,3,2);
imshow(green_image);
title('Recolored to Green (0x00FF00)');

subplot(1,3,3);
imshow(magenta_image);
title('Recolored to Magenta (0xFF00FF)');


%% perform luminescence scaling
scaled_s = ball_s * double(255/max(max(ball_s)));

green_image_scaled = recolor(ball_r,scaled_s,'ff00');
magenta_image_scaled = recolor(ball_r,scaled_s,'ff00ff');

figure('name','Green and magenta balls shading scaled to contain maximum lunimosity');

subplot(1,2,1);
imshow(green_image_scaled);
title('Recolored to Green (0x00FF00)');

subplot(1,2,2);
imshow(magenta_image_scaled);
title('Recolored to Magenta (0xFF00FF)');

%% perform luminescence offset
offset_s = ball_s + (255-max(max(ball_s)));

green_image_offset = recolor(ball_r,offset_s,'ff00');
magenta_image_offset = recolor(ball_r,offset_s,'ff00ff');

figure('name','Green and magenta balls shading offset to contain maximum lunimosity');

subplot(1,2,1);
imshow(green_image_offset);
title('Recolored to Green (0x00FF00)');

subplot(1,2,2);
imshow(magenta_image_offset);
title('Recolored to Magenta (0xFF00FF)');