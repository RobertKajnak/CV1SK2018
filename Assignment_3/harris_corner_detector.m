function [image, H, r, c]  = harris_corner_detector(image_path, threshold, rotation)

% convert to grayscale
original_image = imread(image_path);
image = rgb2gray(im2double(original_image));
%(rotate if needed)
if rotation
    angle = rand * 360;
    original_image = imrotate(original_image,angle);
    % Set area around border to NaN
    Mrot = ~imrotate(true(size(image)),angle);
    image = rgb2gray(im2double(original_image));
    image(Mrot&~imclearborder(Mrot)) = NaN;
end
window_size = 5;

% Calculate Ix and Iy
G = fspecial('gaussian', 5 , 2);
[Gx,Gy] = gradient(G);
Ix = conv2(image, Gx, 'same');
Iy = conv2(image, Gy, 'same');

% Calculate A, B, C
A = conv2(Ix.^2, G, 'same');
B = conv2(Ix.*Iy, G, 'same');
C = conv2(Iy.^2, G, 'same');

% Calculate H
H = zeros(size(image)); 
H(:, :) = (A.*C-B.^2) - 0.04*(A+C).^2;

r = [];
c = [];

%% Find corners 

% including the borders of the image
% for i=1:size(image, 1)
%     for j=1:size(image, 2)
%         window = H(max(1, i-window_size):min(size(image, 1), i+window_size), ...
%             max(1, j-window_size):min(size(image, 2), j+window_size));
%         if H(i,j) == max(window(:)) && H(i,j) > threshold
%             r = [r, i];
%             c = [c, j];
%         end
%     end
% end

% without the borders of the image
for i=1+window_size:size(image, 1)-window_size
    for j=1+window_size:size(image, 2)-window_size
        window = H(i-window_size:i+window_size, j-window_size:j+window_size);
        if H(i,j) == max(window(:)) && H(i,j) > threshold
            r = [r, i];
            c = [c, j];
        end
    end
end

%% plot figures
% since Ix and Iy are grayscale images, they are scaled between their min
% and max
figure(1);
imshow(Ix, [min(Ix(:)), max(Ix(:))]);
figure(2);
imshow(Iy, [min(Iy(:)), max(Iy(:))]);
figure(3);
imshow(original_image);
hold on;
if contains(image_path, 'pingpong')
    scatter(c, r, 100, 'b');
elseif contains(image_path, 'person_toy')
    scatter(c, r, 100, 'r');
else
    scatter(c, r, 100, 'k');
end

end