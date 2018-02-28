im = imread('images/image2.jpg');
%im = rgb2gray(im);

%imshow(im);

%[Gx,Gy] = imgradientxy(im,'sobel');
%[Gmag,Gdir] = imgradient(im,'sobel');

[Gx,Gy,Gmag,Gdir]=compute_gradient(im);

figure('name', 'Gradient of the image');
subplot(2,2,1);
imshow(Gx,[]);
title('Gx');

subplot(2,2,2);
imshow(Gy,[]);
title('Gy');

subplot(2,2,3);
imshow(Gmag,[]);
title('Magnitude');

subplot(2,2,4);
imshow(Gdir,[]);
title('Direction');
