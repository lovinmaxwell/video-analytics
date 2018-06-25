%read the image coda3

barz=imread('barcode.JPG');


barz=rgb2gray(barz);

barz=im2bw(barz);

sz = size(barz)
%size of sz
x=sz(2);

y=sz(1);

xctr=0;

imshow(barz);
%condition checking the areas where image is 1/0
for i=1:1:y
    for j=1:1:x
        if(barz(i,j)<1)
           xctr=1;
           break;
        end
    end
    if xctr==1
        break;
    end
end
% storing the value of corresponding last i,j
x;
xc=j;
yc=i;
io=1;
%starting from the last j value and reading all the rows
for j=xc:1:x
    if (barz(yc,j)<1)
       xd(io)=0;
    end
    if (barz(yc,j)>=1)
       xd(io)=1;
    end
    io=io+1;
end

sxd=size(xd)
%hold on
%for i=1:1:sxd(2)
%if xd(1,i)==0
%plot(i,1,'.');
%hold on
%end
%end

%barcode analysis
%width count
ctr=0;
widthctr=10000;
for i=1:1:sxd(2)
    if xd(1,i)==0
    ctr=ctr+1
    end
    if xd(1,i)==1 && ctr~=0 
        if ctr<=widthctr
        widthctr=ctr;
        end
        ctr=0;
    end
end
width ctr
ho=1;
ctrz=0;
ctro=0;
%barcode binaries
for i=1:1:sxd(2)
    if xd(1,i)==0
    ctrz=ctrz+1;
      if ctrz==widthctr
        bin r(ho)=1;
        ho=ho+1;
        ctrz=0;
      end
    end
    if xd(1,i)==1
    ctro=ctro+1;
      if ctro==widthctr
        bin r(ho)=0;
        ho=ho+1;
        ctro=0;
      end
    end
end
let=size(binr);
let=let(2);
o=1;
for i=12:1:let-10
    numb(o)=binr(i);
    o=o+1;
end
binr
numb;
nume=size(numb);
nume=nume(2);
% template matching
k=1;
nume;