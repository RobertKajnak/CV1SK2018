function [] = hcd_demo()
%% without rotation
[H1, r1, c1] = harris_corner_detector('person_toy/00000001.jpg', 4e-09, false);
[H2, r2, c2] = harris_corner_detector('pingpong/0000.jpeg', 3e-08, false);
%% with random rotation
[H1r, r1r, c1r] = harris_corner_detector('person_toy/00000001.jpg', 4e-09, true);
[H2r, r2r, c2r] = harris_corner_detector('pingpong/0000.jpeg', 3e-08, true);

end