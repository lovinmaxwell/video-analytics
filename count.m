count=0;
t=0;
x=imread('D:\Image Retrieval\2.bmp');
a=rgb2gray(x);
srcFiles = dir('D:\Image Retrieval\*.bmp');  % the folder in which ur images exists
for i = 1 : length(srcFiles)
  filename = strcat('D:\Image Retrieval\',srcFiles(i).name);
  k = imread(filename);
  count=count+1;
  b=rgb2gray(k);
  c=corr2(a,b);
  if c==1
      imwrite(k,'C:\Users\saba\Desktop\images\image1.jpg');
      t=t+1;
  else 
      disp('tow image are not simalr');
  end
end