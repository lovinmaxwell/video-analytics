mycam = webcam;
preview(mycam)
closePreview(mycam)
img = snapshot(mycam);
imagesc(img)
delete(mycam)
clear all