originalImage = imread('yellowlily.jpg');
originalImage = rgb2gray(originalImage);

warning off images:initSize:adjustingMag

figure
imshow(originalImage)
noisyImage = imnoise(originalImage,'gaussian');

figure
imshow(noisyImage)
sobelGradient = imgradient(noisyImage);
figure
imshow(sobelGradient,[])
title('Sobel Gradient Magnitude')
hy = -fspecial('sobel')
hx = hy'
sigma = 2;
smoothImage = imgaussfilt(noisyImage,sigma);
smoothGradient = imgradient(smoothImage,'CentralDifference');

figure
imshow(smoothGradient,[])
title('Smoothed Gradient Magnitude')
