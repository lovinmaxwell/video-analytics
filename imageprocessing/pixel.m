origIm = imread('rice.png');
origImSize = size(origIm)
imActivePixels = 64;
imActiveLines = 48;
inputIm = origIm(1:imActiveLines,1:imActivePixels);
figure
imshow(inputIm,'InitialMagnification',300)
title 'Input Image'
function [pixOut,ctrlOut] = HDLTargetedDesign(pixIn,ctrlIn)

  persistent filt2d
  if isempty(filt2d) 
      filt2d = visionhdl.ImageFilter(...
          'Coefficients',ones(2,2)/4,...
          'CoefficientsDataType','Custom',...
          'CustomCoefficientsDataType',numerictype(0,1,2),...
          'PaddingMethod','Symmetric');
  end
    
  [pixOut,ctrlOut] = filt2d(pixIn,ctrlIn);
end
pixelOut = zeros('numPixelsPerFrame',1,'uint8');
ctrlOut  = repmat(pixelcontrolstruct,numPixelsPerFrame,1);
 for p = 1:numPixelsPerFrame
    [pixelOut(p),ctrlOut(p)] = HDLTargetedDesign(pixel(p),ctrl(p));
 end
[outputIm,validIm] = pix2frm(pixelOut,ctrlOut);
if validIm
    figure
    imshow(outputIm,'InitialMagnification',300)
    title 'Output Image'
end
