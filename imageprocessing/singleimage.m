imagesDir = tempdir;
url = 'http://www-i6.informatik.rwth-aachen.de/imageclef/resources/iaprtc12.tgz';
downloadIAPRTC12Data(url,imagesDir);
trainImagesDir = fullfile(imagesDir,'iaprtc12','images','02');
exts = {'.jpg','.bmp','.png'};
trainImages = imageDatastore(trainImagesDir,'FileExtensions',exts);
numel(trainImages.Files)
miniBatchSize = 64;
scaleFactors = [2 3 4];
source = vdsrImagePatchDatastore(trainImages,...
    'MiniBatchSize',miniBatchSize,...
    'PatchSize',41,...
    'BatchesPerImage',1,...
    'ScaleFactor',scaleFactors);
inputBatch = read(source);
summary(inputBatch)
networkDepth = 20;
firstLayer = imageInputLayer([41 41 1],'Name','InputLayer','Normalization','none');
convolutionLayer = convolution2dLayer(3,64,'Padding',1, ...
    'Name','Conv1');
convolutionLayer.Weights = sqrt(2/(9*64))*randn(3,3,1,64);
convolutionLayer.Bias = zeros(1,1,64);
relLayer = reluLayer('Name','ReLU1');
middleLayers = [convolutionLayer relLayer];
for layerNumber = 2:networkDepth-1
    conv2dLayer = convolution2dLayer(3,64,...
        'Padding',[1 1],...
        'Name',['Conv' num2str(layerNumber)]);
    
    % He initialization
    conv2dLayer.Weights = sqrt(2/(9*64))*randn(3,3,64,64);
    conv2dLayer.Bias = zeros(1,1,64);
    
    relLayer = reluLayer('Name',['ReLU' num2str(layerNumber)]);
    middleLayers = [middleLayers conv2dLayer relLayer];    
end
conv2dLayer = convolution2dLayer(3,1,...
    'NumChannels',64,...
    'Padding',[1 1],...
    'Name',['Conv' num2str(networkDepth)]);
conv2dLayer.Weights = sqrt(2/(9*64))*randn(3,3,64,1);
conv2dLayer.Bias = zeros(1,1,1);
finalLayers = [conv2dLayer regressionLayer('Name','FinalRegressionLayer')];
layers = [firstLayer middleLayers finalLayers];
layers = vdsrLayers();
maxEpochs = 100;
epochIntervals = 1;
initLearningRate = 0.1;
learningRateFactor = 0.1;
l2reg = 0.0001;
options = trainingOptions('sgdm',...
    'Momentum',0.9,...
    'InitialLearnRate',initLearningRate,...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',10,...
    'LearnRateDropFactor',learningRateFactor,...
    'L2Regularization',l2reg,...
    'MaxEpochs',maxEpochs,...
    'MiniBatchSize',miniBatchSize,...
    'GradientThresholdMethod','l2norm',...
    'GradientThreshold',0.01);
doTraining = false;
if doTraining
    modelDateTime = datestr(now,'dd-mmm-yyyy-HH-MM-SS');
    net = trainNetwork(source,layers,options);
    save(['trainedVDSR-' modelDateTime '-Epoch-' num2str(maxEpochs*epochIntervals) 'ScaleFactors-' num2str(234) '.mat'],'net','options');
else
    load('trainedVDSR-Epoch-100-ScaleFactors-234.mat');
end
exts = {'.jpg','.png'};
fileNames = {'sherlock.jpg','car2.jpg','fabric.png','greens.jpg','hands1.jpg','kobi.png',...
    'lighthouse.png','micromarket.jpg','office_4.jpg','onion.png','pears.png','yellowlily.jpg',...
    'indiancorn.jpg','flamingos.jpg','sevilla.jpg','llama.jpg','parkavenue.jpg',...
    'peacock.jpg','car1.jpg','strawberries.jpg','wagon.jpg'};
filePath = [fullfile(matlabroot,'toolbox','images','imdata') filesep];
filePathNames = strcat(filePath,fileNames);
testImages = imageDatastore(filePathNames,'FileExtensions',exts);
montage(testImages)
indx = 1; % Index of image to read from the test image datastore
Ireference = readimage(testImages,indx);
Ireference = im2double(Ireference);
imshow(Ireference)
title('High-Resolution Reference Image');
scaleFactor = 0.25;
Ilowres = imresize(Ireference,scaleFactor,'bicubic');
imshow(Ilowres)
title('Low-Resolution Image');
[nrows,ncols,np] = size(Ireference);
Ibicubic = imresize(Ilowres,[nrows ncols],'bicubic');
imshow(Ibicubic)
title('High-Resolution Image Obtained Using Bicubic Interpolation');
Iycbcr = rgb2ycbcr(Ilowres);
Iy = Iycbcr(:,:,1);
Icb = Iycbcr(:,:,2);
Icr = Iycbcr(:,:,3);
Iy_bicubic = imresize(Iy,[nrows ncols],'bicubic');
Icb_bicubic = imresize(Icb,[nrows ncols],'bicubic');
Icr_bicubic = imresize(Icr,[nrows ncols],'bicubic');
Iresidual = activations(net,Iy_bicubic,41);
Iresidual = double(Iresidual);
imshow(Iresidual,[])
title('Residual Image from VDSR');
Isr = Iy_bicubic + Iresidual;
Ivdsr = ycbcr2rgb(cat(3,Isr,Icb_bicubic,Icr_bicubic));
imshow(Ivdsr)
title('High-Resolution Image Obtained Using VDSR');
roi = [320 30 480 400];
montage({imcrop(Ibicubic,roi),imcrop(Ivdsr,roi)})
title('High-Resolution Results Using Bicubic Interpolation (Left) vs. VDSR (Right)');
bicubicPSNR = psnr(Ibicubic,Ireference);
vdsrPSNR = psnr(Ivdsr,Ireference);
bicubicSSIM = ssim(Ibicubic,Ireference);
vdsrSSIM = ssim(Ivdsr,Ireference);
bicubicNIQE = niqe(Ibicubic);
vdsrNIQE = niqe(Ivdsr);
superResolutionMetrics(net,testImages,scaleFactors);