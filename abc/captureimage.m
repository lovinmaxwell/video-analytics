camList = webcamlist
cam = webcam(1)
img = snapshot(cam);
image(img)
for idx = 1:0
   image(img);
end
for ctr = 1:2
   img = snapshot(cam); % your function goes here
   fname = ['image' num2str(ctr)]; % make a file name
   imwrite(img, fname, 'TIFF');
   pause(5); % or whatever number suits your needs
 end




