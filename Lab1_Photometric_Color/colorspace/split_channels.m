function [ output_image,R,G,B ] = split_channels( input_image )
%SPLIT_CHANNELS Summary of this function goes here
%   Detailed explanation goes here
R = input_image(:,:,1);
G = input_image(:,:,2);
B = input_image(:,:,3);
output_image = zeros(size(input_image));

end

