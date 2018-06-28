frames = 1000
a = imaqhwinfo;
camera_name = char(a.installedadaptors(end));
camera_info = imaqhwinfo(camera_name);
camera_id = camera_info.DeviceInfo.DeviceID(end);
resolution = char(camera_info.DeviceInfo.SupportedFormats(end));
vid = videoinput(camera_name, camera_id, resolution);
FDetect = vision.CascadeObjectDetector('FrontalFaceCART');
% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb');
vid.FrameGrabInterval = 5;
start(vid)
ii=22;
% Set a loop that stop after 100 frames of aquisition
while(vid.FramesAcquired<=50)
    Dinp = getsnapshot(vid);
imshow(Dinp);
pause(1);
out=-1 % if face is not detected
scale=8;
pic2=double(rgb2gray(pic(1:scale:end,1:scale:end,:)));
FDetect = vision.CascadeObjectDetector('FrontalFaceCART');
Dinp = uint8(pic2);
Face = step(FDetect,Dinp);
NumberofFacestobedetected=size(Face,1);
Din=Face(1,:);
Din=imcrop(Dinp ,[Face(1,1) Face(1,2) Face(1,3) Face(1,4)]);
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
end