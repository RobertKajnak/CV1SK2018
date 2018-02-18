clear all;
close all;

%% load files
ball = imread('ball.png');
ball_r = imread('ball_reflectance.png');
ball_s = imread('ball_shading.png');

figure('name','Ball and Shadings');

%% reconstruct image
recon = zeros(size(ball_r));
for i= 1:3
    %the images need to be rescaled to [0,1], so that the multiplication
    %results a value within the same interval
    recon(:,:,i) = im2double(ball_r(:,:,i)).* im2double(ball_s);
end

%% plot
subplot(2,2,1);
imshow(ball);
title('Original Image')

subplot(2,2,2)
imshow(ball_r);
title('Reflectance')

subplot(2,2,3);
imshow(ball_s);
title('Shading');

subplot(2,2,4);
imshow(recon);
title('Reconstructed image')

shg;