function [ output ] = single2triple( input, lin )
%SINGLE2TRIPLE Converts from RGB 32bit color to a 1 byte / color
%representation
% dims: if lin is specified, the array will be flattened to a single
% dimension

if nargin == 2
    output = [mod(bitshift(input,-16),256), ...
                mod(bitshift(input,-8),256), ...
                mod(input,256)];
    output = uint8(output);
else
    output = mod(bitshift(input,-16),256);
    output(:,:,2) = mod(bitshift(input,-8),256);
    output(:,:,3) = mod(input,256);
    output = uint8(output);
end

end

