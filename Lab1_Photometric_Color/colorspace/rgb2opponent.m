function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space

%matlab's lazy copy should prevent this from being copied,
%unless I accidentally modify it
I = input_image;
[output_image,R,G,B] = split_channels(I);

 
 output_image(:,:,1) = (R-G)/sqrt(2);
 output_image(:,:,2) = (R+G-2*B)/sqrt(6);
 output_image(:,:,3) = (R+G+B)/sqrt(3);
 
 
end

