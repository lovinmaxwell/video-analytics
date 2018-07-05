%to detect eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig');

%read the input image
I = imread('C:\Users\sulag\Pictures\Screenshots\download.jpg');
subplot(1,2,1), imshow(I);
BB = step(EyeDetect,I)

rectangle('Position',BB,'LineWidth',3,'LineStyle','-','EdgeColor','r');
title('Eyes Detection');
Eyes = imcrop(I,BB);
subplot(1,2,2), imshow(Eyes);
title('cropped eyes');