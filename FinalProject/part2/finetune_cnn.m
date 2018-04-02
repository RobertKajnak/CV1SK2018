function [net, info, expdir] = finetune_cnn(varargin)

%% Define options
%run(fullfile(fileparts(mfilename('fullpath')), ...
%  '..', '..', '..','matconvnet-1.0-beta23', 'matlab', 'vl_setupnn.m')) ;

opts.modelType = 'lenet' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

 opts.expDir = fullfile('data', ...
   sprintf('cnn_assignment-%s', opts.modelType)) ;
%opts.expDir = fullfile(vl_rootnn, 'data', ...
%  sprintf('cifar-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
%opts.dataDir = fullfile(vl_rootnn, 'data','cifar') ;
%opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

opts.train.gpus = [1];



%% update model

net = update_model();

%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getCaltechIMDB() ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end

end

% -------------------------------------------------------------------------
function imdb = getCaltechIMDB()
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
sets = {'train', 'val'};

%% TODO: Implement your loop here, to create the data structure described in the assignment
data = {};
airplanes_t = dir('../Caltech4/ImageData/airplanes_train/*.jpg');
cars_t = dir('../Caltech4/ImageData/cars_train/*.jpg');
faces_t = dir('../Caltech4/ImageData/faces_train/*.jpg');
motorbikes_t = dir('../Caltech4/ImageData/motorbikes_train/*.jpg');
airplanes_v = dir('../Caltech4/ImageData/airplanes_test/*.jpg');
cars_v = dir('../Caltech4/ImageData/cars_test/*.jpg');
faces_v = dir('../Caltech4/ImageData/faces_test/*.jpg');
motorbikes_v = dir('../Caltech4/ImageData/motorbikes_test/*.jpg');

data_cell = {airplanes_t, cars_t, faces_t, motorbikes_t, ...
            airplanes_v, cars_v, faces_v, motorbikes_v};

tot = 0;
for i = 1:length(data_cell)
    tot = tot + length(data_cell{i});
end
data = cell(1, tot);
labels = cell(1, tot);%zeros(1, tot);
sets = cell(1, tot);%zeros(1, tot);

% for fi = 1:numel(files)
%   fd = load(files{fi}) ;
%   data{fi} = permute(reshape(fd.data',32,32,3,[]),[2 1 3 4]) ;
%   labels{fi} = fd.labels' + 1; % Index from 1
%   sets{fi} = repmat(file_set(fi), size(labels{fi}));
% end

%set = cat(2, sets{:});
%data = single(cat(4, data{:}));

k=1;
for i=1:length(data_cell)
    ims = data_cell{i};
    fprintf('Reading %s',classes{1+mod(i+3,4)});
    %verifies that the img is put into the correct category
    if (1+floor((i-1)/4)==1)
        fprintf(' training...');
    elseif (1+floor((i-1)/4)==2)
        fprintf(' validation...');
    end
    
    for j=1:length(ims)
        file = fullfile(ims(i).folder, ims(i).name);
        image = im2single(imresize(imread(file),[32 32]));
        %image = permute(reshape(image,32,32,3,[]),[2 1 3 4]) ;
        data{k} = image;
        labels{k} = 1+mod(i+3,4);
        sets{k} = 1+floor((i-1)/4);
        k=k+1;
    end
    fprintf(' finished\n');
end
data = single(cat(4, data{:}));

labels = cat(2, labels{:});
sets = cat(2, sets{:});
%%
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);

imdb.images.data = data ;
imdb.images.labels = single(labels) ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end
