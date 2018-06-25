I = imread('circuit.tif');
J = imresize(I,1.25);
figure
imshowpair(I,J,'montage')
axis off
K = imresize(I,[100 150]);
figure, imshow(K)
L = imresize(I,1.5,'bilinear');
figure, imshow(L)
M = imresize(I,.75,'Antialiasing',false);
figure, imshow(M)