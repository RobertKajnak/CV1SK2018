clear all;
close all;

%% load files
awb = imread('awb.jpg');
awb= imread('garden.jpg');

%remove gamma correction from .jpg 
%awbc = rgb2lin(awb);

R = awb(:,:,1);
G = awb(:,:,2);
B = awb(:,:,3);

%% perform color correction
mR = mean(mean(R));
mG = mean(mean(G));
mB = mean(mean(B));

R = R+ (128-mR);
G = G+ (128-mG);
B = B+ (128-mB);

corrected = R;
corrected(:,:,2)=G;
corrected(:,:,3)=B;

%% display result
figure

subplot(1,2,1);
imshow(awb);
title('Original image');

%subplot(1,3,2);
%imshow(awb);
%title('Image after gamma correction is removed');

subplot(1,2,2);
imshow(corrected);
title('Grey World Corrected Image');