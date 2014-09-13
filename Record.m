vidinfo = imaqhwinfo;
numframes = 180;
frames = uint8(zeros(720,1280,3,numframes));

vid = videoinput(vidinfo.InstalledAdaptors{1},1);
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',numframes);
start(vid);

for n=1:numframes
    rawframe = getdata(vid);
    frame = ycbcr2rgb(rawframe);
    frames(:,:,:,n) = frame;
end