vidinfo = imaqhwinfo;

wallcam = videoinput(vidinfo.InstalledAdaptors{1},1);
set(wallcam,'FramesPerTrigger',1);
set(wallcam,'TriggerRepeat',Inf);
set(wallcam,'ReturnedColorSpace','YCbCr');
vid = videoinput(vidinfo.InstalledAdaptors{1},2);
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);
set(vid,'ReturnedColorSpace','YCbCr');

start(wallcam);
start(vid)

background = [];
backgroundWall = [];
wallBoundary = 0;
homography = [];

displayImage = uint8(zeros(600,800));
[X,Y] = meshgrid(1:size(displayImage,2),1:size(displayImage,1));
calibrationPattern = uint8(zeros(size(displayImage,1),size(displayImage,2),3));
slice = uint8(zeros(size(displayImage)));
projectorCentroids = [];

for x=-2:2
    for y=-2:2        
        centerX = size(displayImage,2) / 2 + x*100;
        centerY = size(displayImage,1) / 2 + y*100;        
        slice( (X - centerX).^2 + (Y - centerY).^2 < 1600 ) = 255;
        projectorCentroids = [projectorCentroids, [centerX; centerY]];
    end
end
calibrationPattern(:,:,1) = slice;

h_display = image(displayImage);
set(h_display,'ButtonDownFcn','displayImage = uint8(zeros(600,800));');
colormap('gray');

Calibrate;

%backgroundWall = imresize(backgroundWall,0.25,'bilinear');
%wallBoundary = round(wallBoundary * 0.25) + 1;

%last = [-1,-1];

while true    
    wallFrame = getdata(wallcam);
    frame = getdata(vid);
    
    diff = (double(wallFrame) - double(backgroundWall)).^2;
    dist = diff(:,:,3) + diff(:,:,2);
    pointer = (dist > 40);
    z = getWallIntersection(pointer);

    diff = (double(frame) - double(background)).^2;
    dist = diff(:,:,3) + diff(:,:,2);
    person = (dist > 40);    
    CC = bwconncomp(person,8);    
    [x,y] = detectFingerTip(CC);
    density = computeDensity(CC,x,y);
        
    if z < wallBoundary && density < 0.33
        Z = applyHomography([x;y],homography);
        x = round(Z(1));
        y = round(Z(2));
        displayImage( max(y-2,1):min(y+2,size(displayImage,1)), max(x-2,1):min(x+2,size(displayImage,2)) ) = 256;
%         if (last(1) > 0)
%             
%             alpha=repmat([0.1:0.1:0.9],2,1);
%             interpolants = round(bsxfun(@times,[x;y],alpha) + bsxfun(@times,[last(1);last(2)],1-alpha));
%             
%         end
%         last = [x,y];
    end
    set(h_display,'cdata',displayImage);
        
    flushdata(vid)
    flushdata(wallcam)        
    
end

stop(vid)
stop(wallcam)
flushdata(vid)
flushdata(wallcam)