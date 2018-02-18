function [new_image] = ConvertColorSpace(input_image, colorspace)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts an RGB image into a specified color space, visualizes the 
% color channels and returns the image in its new color space.                     
%                                                        
% Colorspace options:                                    
%   opponent                                            
%   rgb -> for normalized RGB
%   hsv
%   ycbcr
%   gray
%
% P.S: Do not forget the visualization part!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% convert image into double precision for conversions
input_image = im2double(input_image);

if strcmp(colorspace, 'opponent')
    new_image = rgb2opponent(input_image);
    title = 'Opponent Colours';
    subtitles = {'Red-Green','Yellow-Blue','Gray'};
elseif strcmp(colorspace, 'rgb')  
    new_image = rgb2normedrgb(input_image);
    title = 'Normalized RGB';
    subtitles = {'r','g','b'};
elseif strcmp(colorspace, 'hsv')   
    new_image = rgb2hsv(input_image);
    title = 'HSV';
    subtitles = {'Hue','Saturation','Value'};
elseif strcmp(colorspace, 'ycbcr')
    new_image = rgb2ycbcr(input_image);
    title = 'YCbCr';
    subtitles = {'Luma(Y)','Blue Chroma','Red Chroma'};
elseif strcmp(colorspace, 'gray')
    new_image = rgb2grays(input_image); % fill in this function
    title = 'GrayScale';
    subtitles = {'Lightness Method','Avarage Method','Luminosity Method','Matlab Method'};
else
% if user inputs an unknow colorspace just notify and do not plot anything
    fprintf('Error: Unknown colorspace type [%s]...\n',colorspace);
    new_image = input_image;
    return;
end

visualize(new_image,title,subtitles); % fill in this function

end