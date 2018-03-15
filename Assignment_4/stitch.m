function [im,matches, bt] = stitch(im1_str, im2_str)
image1 = imread(im1_str);
image2 = imread(im2_str);
% figure;
% imshow(boat1);
% figure;
% imshow(boat2);
[scores, matches,f1,f2,d1,d2] = keypoint_matching(image2, image1);
if contains(im1_str, 'left') || contains(im1_str, 'right')
    n = 10;
    p = 5;
else
    n = 10;
    p = 50;
end
[bt] = RANSAC(image2, image1, matches, f1, f2, n, p, 1, false);

%W,H
w = size(image2, 2);
h = size(image2, 1);
%the first image is assumed to be in perfect landscape
offsets=[bt.m*[1;1]+bt.t, bt.m*[1;w]+bt.t, ...
    bt.m*[h;1]+bt.t, bt.m*[h;w]+bt.t];
offset(1) = ceil(min(offsets(1,:)));
offset(2) = ceil(min(offsets(2,:)));
disp(offset);
base = image2;
rotated = transform_image(base,bt.m,bt.t);
%calculate the new size for the image
nsz = round([max(offset(2)+size(base,1),size(rotated,1))-min(offset(2),0),...
       max(offset(1)+size(base,2),size(rotated,2))-min(offset(1),0)]);
nsz = [nsz(1),nsz(2)];

%overlay the two images
im = zeros(nsz);
figure;
% im=overlay(im,image1,-offset.*(offset<0));
% im=overlay(im,rotated,offset.*(offset>0));
im = overlay(im, image1, [0,0]);
im = overlay(im, rotated, offset);
im = uint8(im);
imshow(im);
end

%TODO If you know a matlab function for this one, feel free to replace it. 
%The one I found was kinda complicated
function [new_image]=overlay(image1,image2,offset)
    new_image = image1;
    for i=1:size(image2,1)
        for j=1:size(image2,2)
            if image2(i,j)~=0
                new_image(i+offset(2),j+offset(1))=image2(i,j);
            end
        end
    end
end