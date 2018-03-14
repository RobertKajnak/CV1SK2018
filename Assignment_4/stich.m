boat1 = imread('boat1.pgm');
boat2 = imread('boat2.pgm');

[scores, matches,f1,f2,d1,d2] = keypoint_matching(boat2, boat1);
[bt] = RANSAC(boat2, boat1, matches, f1, f2, 10, 50, false);

%W,H
%newsize = [boat