%% load files
sph1 = imread('sphere1.ppm');
sph2 = imread('sphere2.ppm');

sy1 = imread('synth1.pgm');
sy2 = imread('synth2.pgm');


%% Calculate and display results

Lucas_kanade(sph1,sph2);
Lucas_kanade(sy1,sy2);