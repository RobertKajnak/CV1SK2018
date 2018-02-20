clear all;
close all;

%% load files
awb = imread('awb.jpg');
%awb= imread('garden.jpg');

%remove gamma correction from .jpg 
%awbc = rgb2lin(awb);

R = awb(:,:,1);
G = awb(:,:,2);
B = awb(:,:,3);

%% perform color correction
percentile = 10*255/100;

pruning = 0;
if pruning == 0
    disp('No pruning:');
    mR = mean(mean(R));
	mG = mean(mean(G));
    mB = mean(mean(B));
else
    disp('Luminosity pruning');
    mR = mean(mean(R((R+G+B)/3>percentile & (R+G+B)/3<255-percentile)));
    mG = mean(mean(G((G+G+B)/3>percentile & (G+G+B)/3<255-percentile)));
    mB = mean(mean(B((B+G+B)/3>percentile & (B+G+B)/3<255-percentile)));
end
m=(mR+mG+mB)/3;

R = R+ (128-mR);
G = G+ (128-mG);
B = B+ (128-mB);

%reconstruct image from channels
corrected = R;
corrected(:,:,2)=G;
corrected(:,:,3)=B;

cR = mean(mean(corrected(:,:,1)));
cG = mean(mean(corrected(:,:,2)));
cB = mean(mean(corrected(:,:,3)));

%test distance from target
target = [128.0,128.0,128.0];

fprintf('The avarage has been corrected from MSE = %d, values of RBG channels of:\n',mse([mR,mG,mB],target));
disp([mR,mG,mB]);
fprintf('to MSE = %d with channel values:\n',mse([cR,cG,cB],target));
disp([cR,cG,cB]);
%% display result
figure

%awb = lin2rgb(awb)
%corrected = lin2rgb(corrected)

subplot(1,2,1);
imshow(awb);
title('Original image');

%subplot(1,3,2);
%imshow(awb);
%title('Image after gamma correction is removed');

subplot(1,2,2);
imshow(corrected);
title('Grey World Corrected Image');