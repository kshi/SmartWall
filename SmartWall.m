vidinfo = imaqhwinfo;
visualize = true;

wallcam = videoinput(vidinfo.InstalledAdaptors{1},2);
set(wallcam,'FramesPerTrigger',1);
start(wallcam);

vid = videoinput(vidinfo.InstalledAdaptors{1},1);
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);

start(vid)

background = [];
backgroundWall = [];
wallBoundary = 0;
homography = [];

Calibrate;

displayImage = uint8(zeros(size(background,2),size(background,1)));

if visualize
    figure(1)
    subplot(121)
    h_pointer = displayImage;
    subplot(122)
    h_wall = displayImage;
else
    figure(1)
    h_display = displayImage;
end

while true
    wallFrame = getdata(wallcam);
    
    diff = (double(wallFrame) - double(backgroundWall)).^2;
    dist = diff(:,:,3) + dist(:,:,2) + diff(:,:,1)*0.2;
    pointer = (dist > 40);
    [t,z] = detectFingerTip(person,'down');
    if visualize
        wallDisplay = uint8(zeros(size(displayImage)));
        drawDisplayBox(wallDisplay,t,z);
        wallDisplay(z,:) = 256;
        set(h_wall,'cdata',wallDisplay);
    end
    frame = getdata(vid);
    diff = (double(frame) - double(background)).^2;
    dist = diff(:,:,3) + diff(:,:,2) + diff(:,:,1) * 0.2;      
    person = (dist > 40);    
    [x,y] = detectFingerTip(person,'right');
    if visualize
        trackDisplay = uint8(zeros(size(displayImage)));
        drawDisplayBox(trackDisplay,x,y);
        set(h_pointer,'cdata',trackDisplay);
        computeDensity(person,x,y);    
    end
    if density > 0.33
        %erase
    else
        %draw
    end        
        
    flushdata(vid)
    flushdata(wallcam)
    
end

stop(vid)
stop(wallcam)
flushdata(vid)
flushdata(wallcam)