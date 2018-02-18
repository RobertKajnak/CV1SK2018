function [ output ] = triple2single( input)
%TRIPLE2SINGLE Converts from RGB 1 byte / color to a 32bit color
%representation

output = bitshift(uint32(input(:,:,1)),16) + ...
               bitshift(uint32(input(:,:,2)),8) + ...
               uint32(input(:,:,3));
end

