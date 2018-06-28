% 1 is the default id of webcam
vid = videoinput;
% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 5;

%start the video aquisition here
start(vid)

% Set a loop that stop after 400 frames of aquisition
while(vid.FramesAcquired<=400)
    
    % Get the snapshot of the current frame
    im = getsnapshot(vid);
    
    % Now to detect red objects in real time we have to subtract the red component layer
    % from the grayscale image to extract all the red objects in the image.
    im2 = imsubtract(data(:,:,1), rgb2gray(data));
    %Use a median filter to filter out noise in the image
    im3 = medfilt2(im2,[3 3]);
    % Convert the resulting grayscale image into a binary image.
    im4 = im2bw(im3,0.18);
    
    % Remove all those objects less than 300 pixels
     im5 = bwareaopen(im4,300);
    
    % Label all the connected components in the image.
    bw = bwlabel(im5, 8);
    
   
    % We get a set of properties for each labeled region.
  stats=regionprops(bw,'BoundingBox','Centroid');
    
    % Display the image
    imshow(im)
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1),bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
    
    hold off
end
% Both the loops end here.

% Stop the video aquisition.
stop(vid);

% Flush all the image data stored in the memory buffer.
flushdata(vid);

% Clear all variables
clear all