% disp('gray');
% [C, A] = bow_build_vocab('sift', 'gray');
% save('sift-gray.mat', 'C', 'A');
% 
% disp('RGB');
% [C, A] = bow_build_vocab('sift', 'RGBsift');
% save('sift-RGB.mat', 'C', 'A');
% 
% 
% disp('rgb');
% [C, A] = bow_build_vocab('sift', 'rgbsift');
% save('sift-nrgb.mat', 'C', 'A');
% 
% disp('opponent');
% [C, A] = bow_build_vocab('sift', 'opponentsift');
% save('sift-opponent.mat', 'C', 'A');


% disp('gray');
% [C, A] = bow_build_vocab('dsift', 'gray');
% save('dsift-gray.mat', 'C', 'A');
% 
% clear
% 
% disp('RGB');
% [C, A] = bow_build_vocab('dsift', 'RGBsift');
% save('dsift-RGB.mat', 'C', 'A');
% 
% clear
% 
% disp('rgb');
% [C, A] = bow_build_vocab('dsift', 'rgbsift');
% save('dsift-nrgb.mat', 'C', 'A');
% 
% clear
% 
% disp('opponent');
% [C, A] = bow_build_vocab('dsift', 'opponentsift');
% save('dsift-opponent.mat', 'C', 'A');
% clear
% 
% disp('800');
% [C, A] = bow_build_vocab('dsift', 'gray', 800);
% save('dsift-gray-800.mat', 'C', 'A');
% 
% clear
% 
% disp('1600');
% [C, A] = bow_build_vocab('dsift', 'gray', 1600);
% save('dsift-gray-1600.mat', 'C', 'A');
% 
% clear
% 
% disp('2000');
% [C, A] = bow_build_vocab('dsift', 'gray', 2000);
% save('dsift-gray-2000.mat', 'C', 'A');
% 
% clear

disp('4000');
[C, A] = bow_build_vocab('dsift', 'gray', 4000);
save('dsift-gray-4000.mat', 'C', 'A');


