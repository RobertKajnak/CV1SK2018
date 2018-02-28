%close all;

im = imread('images/image2.jpg');

for i=3:3
    figure;
    imres = compute_LoG(im,i);
    imshow(imres);
end