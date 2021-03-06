Detector = vision.CascadeObjectDetector();
%set properties in video objects
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
cam = webcam();
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
%start video acquisition

%set a loop for frames
while(Detector.FramesAcquired<=500)
        im = getsnapshot(Detector);
 %get snapshot of current frams
 data = getsnapshot(Detector);
 %track red object in real time
 %we have to substract the red components
 %from the grey scale image to extract the red component in the image
 diff_im = imsubstract(data(1,1,1), rgb2gray(data));
 %use a media filter to filter out noise
 diff_im = medfilt2(diff_im, [3 3]);
 %convert gray scale image into binary image
 diff_im = im2bw(diff_im,0.18);
 %remove all those pixel less than 300px
 diff_im = bwareaopen(diff_im,300);
 %label the connected components in the image
 bw = bwlabel(diff_in,0);
 %image analysis
 %we get set of properties
 stata = regionpropa(bw,'Boundingbox','centroid')
 %display the image
 imshow(data)
 hold on
 %loop to bound the red objects
 for object = 1:length(state)
     bb = state(object).BoundingBox;
     bc = state(object).Centroid;
     rectangle('Position',bb,'EdgeColor','r','LineWidth',2);
     plot(bc(1),bc(2),'-m+')
     a=text (bc(1),bc(2), strcat('X: ', num2str(round(bc(1))), ' Y: ', num2str(round(bc(2)))));
     set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize',12, 'Color', 'yellow');
 end
 hold off
 end
% Both the loops end here.

% Stop the video aquisition.
stop(Detector);

% Flush all the image data stored in the memory buffer.
flushdata(Detector);

% Clear all variables
clear all
 