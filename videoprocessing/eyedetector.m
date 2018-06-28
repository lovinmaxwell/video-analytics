frames = 1000;
faceDetector = vision.CascadeObjectDetector();
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
 
cam = webcam();
 
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
 
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);
runLoop = true;
numPts = 0;
frameCount = 0;
 a = imaqhwinfo;
FDetect = vision.CascadeObjectDetector('FrontalFaceCART');
% Set the properties of the video object
vid.FrameGrabInterval = 5;

if Face~=-1
       out=zeros(5,4);

        %     Use only the biggest Face found and rescale bounding box to original
        %     size
            pos = find( Face(:,3)==max(Face(:,3)));
            pos=pos(1);
            out(1,:)=(Face(pos,:)*scale);
            siz=out(1,3);

        %     Create Bounding Box for Right Eyes
            left=0.2;
            right=0.58;
            oben=.28;
            unten=0.5;
            out(3,:)=[out(1,1)+siz*left,out(1,2)+siz*oben,siz*(1-right-left),siz*(1-oben-unten)];

        %     Create Bounding Box for Left Eyes
            left=0.58;
            right=0.2;
            oben=.28;
            unten=0.5;
            out(4,:)=[out(1,1)+siz*left,out(1,2)+siz*oben,siz*(1-right-left),siz*(1-oben-unten)];

end
if out ~=-1

	BB4(1,1)=out(4,1);
    BB4(1,2)=out(4,2);
    BB4(1,3)=out(4,3);
    BB4(1,4)=out(4,4);
    BB5(1,1)=out(3,1);
    BB5(1,2)=out(3,2);
    BB5(1,3)=out(3,3);
    BB5(1,4)=out(3,4);
    hold on;
    imshow(Dinp);
    rectangle('Position',BB4(1,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
    rectangle('Position',BB5(1,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
    pause(1);
    hold off   

end