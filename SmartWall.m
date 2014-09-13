vidinfo = imaqhwinfo;

%wallcam = videoinput(vidinfo.InstalledAdaptors{1},2);
%set(wallcam,'FramesPerTrigger',1);
%start(wallcam);
vid = videoinput(vidinfo.InstalledAdaptors{1},1);
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);

localized = false; 


while true
    rawframe = getdata(vid);
    % check for wall contact
    
    
    
    % if contact
    start(vid)
    ycbcrframe = getsnapshot(vid);
    frame = ycbcr2rgb(ycbcrframe);
    
    
    if localized == true
        
        
    else % first contact
        
    end
    
    % if no contact
    %stop(vid)
    
end

closepreview;
stop(vid);