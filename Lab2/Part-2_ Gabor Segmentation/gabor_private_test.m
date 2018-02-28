img = imread('./data/robin-1.jpg');
resize_factor = 1;
img      = imresize(img,resize_factor);
img = rgb2gray(img);

figure(1), imshow(img)

sigma = .5;
theta = 10;
lambda = 10;
psi =0;
gamma = 0.3;

gab = createGabor( sigma, theta, lambda, psi, gamma );

figure;
subplot(2,1,1)
imshow(gab(:,:,2),[]);

%filtered = imfilter(img,gab(:,:,1));
%subplot(2,1,2);
%imshow(filtered);