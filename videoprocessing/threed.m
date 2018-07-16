
%% Initialization
vidLeft = VideoReader('Left.AVI'); % read left shifted video recorded in the left camera
vidRight = VideoReader('Right.AVI'); % read right shifted video recorded in the right camera

writerObj = VideoWriter('vdo3d.avi'); % create a writer object for corresponding 3D video
open(writerObj); % open the writer object

nFrames = vidLeft.NumberOfFrames; % Get total number of frames, height and width of both the videos
vidHeight = vidLeft.Height;
vidWidth = vidLeft.Width;

movie3d(1:nFrames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []); % create movie object

%% Processing Loops
for k = 1 : nFrames
    leftI3chan = read(vidLeft, k); % read each frame of left and right videos
	RightI3chan = read(vidRight, k);
    leftI = rgb2gray(leftI3chan); % convert them to gray frames
    rightI = rgb2gray(RightI3chan);
    movie3d(k).cdata = cat(3,rightI,leftI,leftI); % mix the layer
	% Now there is a small correction I must point out. In your 3D spectacle if the left glass is Cyan and right glass is Magenta, then you have to make no change. But if your glass is just opposite i.e. Left glass is Magenta and Right glass is Cyan, you have to replace the line with the following line.
    % movie3d(k).cdata = cat(3,leftI,rightI,rightI);
    writeVideo(writerObj,movie3d(k).cdata); % write the frame in the movie object
end

hf = figure;
set(hf, 'position', [150 150 vidWidth vidHeight]);
movie(hf, movie3d, 1, 30); % show the final movie

%% Clear memrory
close(writerObj);
clear all;
clc;