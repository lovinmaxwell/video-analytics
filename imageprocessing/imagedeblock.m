imagesDir = tempdir;
url = "http://www-i6.informatik.rwth-aachen.de/imageclef/resources/iaprtc12.tgz";
downloadIAPRTC12Data(url,imagesDir);
trainImagesDir = fullfile(imagesDir,'iaprtc12','images','00');
exts = {'.jpg','.bmp','.png'};
trainImages = imageDatastore(trainImagesDir,'FileExtensions',exts);
numel(trainImages.Files)
originalFileLocation = fullfile(imagesDir,'iaprtc12','images','00');

% Make a folder structure for the training data
if ~exist(fullfile(imagesDir,'iaprtc12','JPEGDeblockingData','Original'),'dir')
    mkdir(fullfile(imagesDir,'iaprtc12','JPEGDeblockingData','Original'));
end
if ~exist(fullfile(imagesDir,'iaprtc12','JPEGDeblockingData','Compressed'),'dir')
    mkdir(fullfile(imagesDir,'iaprtc12','JPEGDeblockingData','Compressed'));
end

uncompressedFileLocation = fullfile(imagesDir,'iaprtc12','JPEGDeblockingData','Original');
compressedFileLocation = fullfile(imagesDir,'iaprtc12','JPEGDeblockingData','Compressed');
files = dir([originalFileLocation filesep '*.jpg']);
imNumber = 1;
for fileIndex = 1:size(files,1)
    fname = [originalFileLocation filesep files(fileIndex).name];
    im = imread(fname);
    if size(im,3) == 3
        im = rgb2gray(im);
    end
    for index = 1:length(JPEGQuality)
        imwrite(im,[uncompressedFileLocation filesep num2str(imNumber) '.jpg'],'JPEG','Quality',100)
        imwrite(im,[compressedFileLocation filesep num2str(imNumber) '.jpg'],'JPEG','Quality',JPEGQuality(index))
        imNumber = imNumber + 1;
    end
end
batchSize = 128;
patchSize = 50;
batchesPerImage = 1;

exts = {'.jpg'};
imdsUncompressed = imageDatastore(uncompressedFileLocation,'FileExtensions',exts);
imdsCompressed = imageDatastore(compressedFileLocation,'FileExtensions',exts);

ds = JPEGimagePatchDatastore(imdsUncompressed,imdsCompressed,...
    'MiniBatchSize',batchSize,...
    'PatchSize',patchSize,...
    'BatchesPerImage',batchesPerImage);
inputBatch = read(ds);
summary(inputBatch)
layers = dnCNNLayers()
maxEpochs = 30;
initLearningRate = 0.1;
l2reg = 0.0001;
batchSize = 128;

options = trainingOptions('sgdm',...
    'Momentum',0.9,...
    'InitialLearnRate',initLearningRate,...
    'LearnRateSchedule','piecewise',...
    'GradientThresholdMethod','absolute-value',...
    'GradientThreshold',0.005,...
    'L2Regularization',l2reg,...
    'MiniBatchSize',batchSize,...
    'MaxEpochs',maxEpochs,...
    'Plots','training-progress');
% Training runs when doTraining is true
doTraining = false; 
if doTraining     
    [net, info] = trainNetwork(ds,layers,options); 
else 
    load('pretrainedJPEGDnCNN.mat'); 
end
exts = {'.jpg','.png'};
fileNames = {'sherlock.jpg','car2.jpg','fabric.png','greens.jpg','hands1.jpg','kobi.png',...
    'lighthouse.png','micromarket.jpg','office_4.jpg','onion.png','pears.png','yellowlily.jpg',...
    'indiancorn.jpg','flamingos.jpg','sevilla.jpg','llama.jpg','parkavenue.jpg',...
    'peacock.jpg','car1.jpg','strawberries.jpg','wagon.jpg'};
filePath = [fullfile(matlabroot,'toolbox','images','imdata') filesep];
filePathNames = strcat(filePath,fileNames);
testImages = imageDatastore(filePathNames,'FileExtensions',exts);
indx = 7; % Index of image to read from the test image datastore
Ireference = readimage(testImages,indx);
imshow(Ireference)
title('Uncompressed Reference Image')
imwrite(Ireference,fullfile(tempdir,'testQuality10.jpg'),'Quality',10);
imwrite(Ireference,fullfile(tempdir,'testQuality20.jpg'),'Quality',20);
imwrite(Ireference,fullfile(tempdir,'testQuality50.jpg'),'Quality',50);
I10 = imread(fullfile(tempdir,'testQuality10.jpg'));
I20 = imread(fullfile(tempdir,'testQuality20.jpg'));
I50 = imread(fullfile(tempdir,'testQuality50.jpg'));
montage({I50,I20,I10},'Size',[1 3])
title('JPEG-Compressed Images with Quality Factor: 50, 20 and 10 (left to right)')
I10ycbcr = rgb2ycbcr(I10);
I20ycbcr = rgb2ycbcr(I20);
I50ycbcr = rgb2ycbcr(I50);
I10y_predicted = denoiseImage(I10ycbcr(:,:,1),net);
I20y_predicted = denoiseImage(I20ycbcr(:,:,1),net);
I50y_predicted = denoiseImage(I50ycbcr(:,:,1),net);
I10ycbcr_predicted = cat(3,I10y_predicted,I10ycbcr(:,:,2:3));
I20ycbcr_predicted = cat(3,I20y_predicted,I20ycbcr(:,:,2:3));
I50ycbcr_predicted = cat(3,I50y_predicted,I50ycbcr(:,:,2:3));
I10_predicted = ycbcr2rgb(I10ycbcr_predicted);
I20_predicted = ycbcr2rgb(I20ycbcr_predicted);
I50_predicted = ycbcr2rgb(I50ycbcr_predicted);
montage({I50_predicted,I20_predicted,I10_predicted},'Size',[1 3])
title('Deblocked Images with Quality Factor: 50, 20 and 10 (left to right)')
roi = [30 440 100 80];
i10 = imcrop(I10,roi);
i20 = imcrop(I20,roi);
i50 = imcrop(I50,roi);
montage({i50 i20 i10},'Size',[1 3])
title('Patches from JPEG-Compressed Images with Quality Factor: 50, 20 and 10 (left to right)');
i10predicted = imcrop(I10_predicted,roi);
i20predicted = imcrop(I20_predicted,roi);
i50predicted = imcrop(I50_predicted,roi);
montage({i50predicted,i20predicted,i10predicted},'Size',[1 3])
title('Patches from Deblocked Images with Quality Factor: 50, 20 and 10 (left to right)')