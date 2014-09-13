vidinfo = imaqhwinfo;

%wallcam = videoinput(vidinfo.InstalledAdaptors{1},2);
%set(wallcam,'FramesPerTrigger',1);
%start(wallcam);
vid = videoinput(vidinfo.InstalledAdaptors{1},1);
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);

start(vid)

n = 0;
initialized = false;
staticFrame = [];

while true
    %rawframe = getdata(vid);
    % check for wall contact
    
    
    
    % if contact
    %start(vid)
    frame = getdata(vid);
    if initialized
       diff = (double(frame) - double(staticFrame)).^2;
       dist = diff(:,:,3) + diff(:,:,2) + diff(:,:,1) * 0.2;       
       person = (dist > 40);
       CC = bwconncomp(person,8);
       numPixels = cellfun(@numel, CC.PixelIdxList);
       [~,idx] = max(numPixels);
       [Y,X] = ind2sub(CC.ImageSize,CC.PixelIdxList{idx});
       [~,RHS] = max(X);
       
       strip = uint8(zeros(CC.ImageSize));
       strip(:, max(X(RHS)-100,1):X(RHS)) = 8;
       detections = uint8(zeros(CC.ImageSize));
       detections(CC.PixelIdxList{idx}) = 8;
       detections = detections .* strip;
       
       far = abs(X - X(RHS)) > 50;
       Y(far) = [];
       X(far) = [];
       [~,pointId] = min(Y);

       j = Y(pointId);
       i = X(pointId);
       detections(max(j-5,1):min(j+5,720), max(i-5,1):min(i+5,1280)) = 256;
       
       localPatch = detections(max(j-20,1):min(j+20,720), max(i-20,1):min(i+20,1280)) > 0;
       density = sum(localPatch(:)) / numel(localPatch(:))
       
       if density > 0.33
           % erase
       else
           % draw
       end
       
       localContour = edge(localPatch);
       
       imshow(detections)
    else
        n = n + 1;
        if n == 20
            initialized = true;
            staticFrame = frame;
        end
    end
    

    % if no contact
    %stop(vid)
    
    flushdata(vid)
    
end

stop(vid);