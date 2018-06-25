% Set up for stream
nFrames = 0;
while (nFrames<1000)     % Process for the first 100 frames.
    % Acquire single frame from imaging device.
    frameRGB = vidDevice();

    % Compute the optical flow for that particular frame.
    flow = estimateFlow(opticFlow,rgb2gray(frameRGB));

    imshow(frameRGB)
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',25)
    hold off

    % Increment frame count
    nFrames = nFrames + 1;
end
