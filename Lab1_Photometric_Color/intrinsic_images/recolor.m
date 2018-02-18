function [ colored_image ] = recolor( reflectance, shading, new_color )
%RECOLOR Summary of this function goes here
%   Detailed explanation goes here

reflectance = triple2single(reflectance);
reflectance(reflectance>0)= hex2dec(new_color);
reflectance = single2triple(reflectance);

colored_image = zeros(size(reflectance));
for i= 1:3
    %the images need to be rescaled to [0,1], so that the multiplication
    %results a value within the same interval
    colored_image(:,:,i) = im2double(reflectance(:,:,i)).* im2double(shading);
end

end

