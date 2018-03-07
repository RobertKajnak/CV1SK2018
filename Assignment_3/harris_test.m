toy = imread('person_toy/00000001.jpg');
pong = imread('pingpong/0000.jpeg');
%%
[H,r,c] = harris_corner_2(toy,1e-7);
[H,r,c] = harris_corner_2(pong,1e-7);
%%
[H,R,C] = harris_corner_detector('person_toy/00000001.jpg',1e-7,0);
[H,R,C] = harris_corner_detector('pingpong/0000.jpeg',1e-7,0);
