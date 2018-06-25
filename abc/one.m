%load pic
D = squeeze(D);
image_num = 8;
image(D(:,:,image_num))
axis image
colormap(map)
x = xlim;
y = ylim;
contourslice(D,[],[],image_num)
axis ij
xlim(x)
ylim(y)
daspect([1,1,1])
colormap('default')
phandles = contourslice(D,[],[],[1,12,19,27],8);
view(3); axis tight
set(phandles,'LineWidth',2)
Ds = smooth3(D);
hiso = patch(isosurface(Ds,5),...
  'FaceColor',[1,.75,.65],...
  'EdgeColor','none');
hcap = patch(isocaps(D,5),...
  'FaceColor','interp',...
  'EdgeColor','none');
colormap(map)
view(45,30) 
axis tight 
daspect([1,1,.4])
lightangle(45,30); lighting phong
isonormals(Ds,hiso)
set(hcap,'AmbientStrength',.6)
set(hiso,'SpecularColorReflectance',0,'SpecularExponent',50)