%%take video from webcam
vid=videoinput('Winvideo',1,'YUY2_320x240');
%set frames trigger
set(vid,'FramesPerTrigger', Inf);
% video output is rgb color
set(vid,'ReturnedColorspace','rgb');
% set video frame interval 1
vid.FrameGrabinterval = 1
% start video
start(vid);
%start loop till frame 10000
while(vid.FramesAcquired<=1000)
% get snapshot of video
data=getsnapshot(vid);
%  red color extraction
red=data(:,:,1);
% convert picture into gray
gray=rgb2gray(data);
% subtract red to gray frame
diff_im=imsubtract(red,gray);
% use median filter
diff_im=medfilt2(diff_im,[3,3]);
% convert image into binary
diff_im=im2bw(diff_im,0.10);
% use blob statistics analysis on this image
diff_im=bwareaopen(diff_im,1000);
bw=bwlabel(diff_im,8);
% use boundbox to enbox red color object
stats=regionprops(bw,'BoundingBox','Centroid');
image(data);
hold on
% identify no of red object in image
for(object=1:length(stats))
bb=stats(object).BoundingBox;
bc=stats(object).Centroid;
rectangle('Position',bb,'EdgeColor','r','LineWidth',2);
plot(bc(1),bc(2),'-m+')
a=text(bc(1)+15,bc(2),strcat('X: ',num2str(round(bc(1))),'Y: ',num2str(round(bc(2)))));
set(a,'FontName','Arial','FontWeight','bold','FontSize',12,'Color','yellow');
if(length(stats)==1)
% show label one with one object
a=text(50,60,strcat('One'));
set(a,FontName,Arial,FontWeight,bold,FontSize,12,Color,'red');
end
if(length(stats)==2)
% show label two with two red object
a=text(50,60,strcat('Two'));
set(a,'FontName','Arial','FontWeight','bold','FontSize',12,'Color','red');
end
if(length(stats)==3)
% show label three with three red object
a=text(50,60,strcat('three'));
set(a,'FontName','Arial','FontWeight','bold','FontSize',12,'Color','red');
end
if(length(stats)==4)
% show label four with four red object
a=text(50,60,strcat('four'));
set(a,'FontName','Arial','FontWeight','bold','FontSize',12,'Color','red');
end
end
hold off
% end loop
end
% stop video
stop(vid);
% flush data
flushdata(vid);
% clear all
clear all;
