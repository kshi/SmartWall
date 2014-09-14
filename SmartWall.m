vidinfo = imaqhwinfo;
visualize = false;

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

Calibrate;

%backgroundWall = imresize(backgroundWall,0.25,'bilinear');
%wallBoundary = round(wallBoundary * 0.25) + 1;

displayImage = uint8(zeros(size(background,1),size(background,2)));

figure(1)
if visualize
    subplot(121)
    h_pointer = imshow(displayImage);
    subplot(122)
    h_wall = imshow(displayImage);
else
    h_display = imshow(displayImage);
end

profile on

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
    density = computeDensity(CC,x,y)
    
    if visualize
        wallDisplay = uint8(zeros(size(displayImage)));
        wallDisplay(z,:) = 128;
        wallDisplay(wallBoundary,:) = 256;
        set(h_wall,'cdata',wallDisplay);
        if z < wallBoundary
            title('contact')
        else
            title('')
        end
        
        CC = bwconncomp(person,8);
        numPixels = cellfun(@numel, CC.PixelIdxList);
        [~,idx] = max(numPixels);
        strip = uint8(zeros(CC.ImageSize));
        strip(:, max(x-100,1):x) = 8;
        detections = uint8(zeros(CC.ImageSize));
        detections(CC.PixelIdxList{idx}) = 8;
        detections = detections .* strip;
        detections(max(y-5,1):min(y+5,720), max(x-5,1):min(x+5,1280)) = 256;
        set(h_pointer,'cdata',detections);
    else
        if z < wallBoundary && density < 0.33
            displayImage( max(y-2,1):min(y+2,size(displayImage,1)), max(x-2,1):min(x+2,size(displayImage,2)) ) = 256;
        end
        set(h_display,'cdata',displayImage);
    end
        
    flushdata(vid)
    flushdata(wallcam)
    
end

stop(vid)
stop(wallcam)
flushdata(vid)
flushdata(wallcam)