close all

img = imread('./data/robin-1.jpg');
resize_factor = 1;
img      = imresize(img,resize_factor);
img = rgb2gray(img);


sigma = 2;
theta = 0;
lambda = 10;
psi = 0;
gamma = 0.5;

gab = createGabor( sigma, theta, lambda, psi, gamma );
%min(min(gab))
%max(max(gab))


figure;
subplot(1,2,1);
imshow(gab(:,:,1),[]);

subplot(1,2,2);
imshow(gab(:,:,2),[]);

figure;
subplot(3,1,1);
imshow(img)
subplot(3,1,2);
filtered = imfilter(img,gab(:,:,1));
imshow(filtered);
subplot(3,1,3);
filtered = imfilter(img,gab(:,:,2));
imshow(filtered);