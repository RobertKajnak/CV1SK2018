boat1 = imread('boat1.pgm');
boat2 = imread('boat2.pgm');
% figure;
% imshow(boat1);
% figure;
% imshow(boat2);
[scores, matches,f1,f2,d1,d2] = keypoint_matching(boat2, boat1);
[bt] = RANSAC(boat2, boat1, matches, f1, f2, 10, 50, 1);

%W,H
%the first image is assumed to be in perfect landscape
X1= [0,size(boat1,2),0,size(boat1,2),0];