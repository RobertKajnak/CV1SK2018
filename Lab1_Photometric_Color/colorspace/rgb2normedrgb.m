function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb
[output_image,R,G,B] = split_channels(input_image);
RGB = R+G+B;%They say memory is cheaper than processing power
output_image(:,:,1) = R./RGB;
output_image(:,:,2) = G./RGB;
output_image(:,:,3) = B./RGB;
end

