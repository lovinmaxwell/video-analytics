count=0;
t=0;
x=imread('C:\Matlab\alia.jpg');
a=rgb2gray(x);
srcFiles = dir('C:\Matlab\alia.jpg');  % the folder in which ur images exists
for i = 1 : length(srcFiles)
  filename = strcat(('C:\Matlab\alia.jpg'),srcFiles(i).name);
  k = imread(filename);
  count=count+1;
  b=rgb2gray(k);
  c=corr2(a,b);
  if c==1
      imwrite(k,'C:\Matlab\Alia-Bhatt.jpg');
      t=t+1;
  else 
      disp('tow image are not simalr');
  end
end
