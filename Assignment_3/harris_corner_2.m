function [H,r,c] = harris_corner_2(image, threshold)
%HARRIS_CORNER_2 Summary of this function goes here
%   Detailed explanation goes here

image = rgb2gray(image);
image = im2double(image);

wd = 5;

%Get gaussian filter
g = fspecial('gaussian',[5 5],2);
%First order derivate = gradient
[gdx, gdy] = gradient(g);

%Get Ix,Iy based on the first order derivative
Ix = imfilter(image,gdx);
Iy = imfilter(image,gdy);

A = imgaussfilt(Ix.^2,2);
B = imgaussfilt(Ix.*Iy,2);
C = imgaussfilt(Iy.^2,2);
D = B;

H = (A.*C - B.^2) - 0.04*(A+C).^2;

sz = size(H);
%for the number of corners, this should be negligible array size increase
r = [];
c = [];
%calculates the center point of the window when the matrix is flattened
center = round((2*wd+1)^2/2);

for i=1+wd:sz(1)-wd
    for j =1+wd:sz(2)-wd
        window = H(i-wd:i+wd,j-wd:j+wd);
        %this ensures that the value is strictly greater than all other
        %values in the window
        maxval = max(max(window));
        ind = find(window==maxval);
        if  ind == center && H(i,j)>threshold
            r = [r,i];
            c = [c,j];
        end
    end
end

figure;
imshow(Ix,[]);
figure;
imshow(Iy,[]);
for i = 1:length(r)
    image(r(i)-3:r(i)+3,c(i)-3:c(i)+3) = ones(7);
end
figure;
imshow(image)
end

