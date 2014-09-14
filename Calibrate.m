% Background Calibration
calib_skip = 15;
calib_iters = 30;
for n=1:calib_skip
    frame = getdata(vid);
    wallFrame = getdata(wallcam);
    flushdata(vid)
    flushdata(wallcam)
end
flushdata(vid)
flushdata(wallcam)
background = zeros(size(frame));
backgroundWall = zeros(size(wallFrame));
for n=1:calib_iters
    frame = getdata(vid);
    wallFrame = getdata(wallcam);
    background = background + double(frame);
    backgroundWall = backgroundWall + double(wallFrame);
    flushdata(vid)
    flushdata(wallcam)    
end
background = uint8(background / calib_iters);
backgroundWall = uint8(backgroundWall / calib_iters);
fprintf('Background calibrated.\n');
flushdata(vid)
flushdata(wallcam)

set(h_display,'cdata',calibrationPattern);
drawnow
pause(2)
flushdata(vid)
flushdata(wallcam)
frame = getdata(vid);
diff = (double(frame) - double(background)).^2;
dist = diff(:,:,3) + diff(:,:,2);
circles = (dist > 80);
CC = bwconncomp(circles,8);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,I] = sort(numPixels);

centroids = regionprops(CC,'Centroid');
centroids = cat(1,centroids.Centroid);
centroids = centroids(I(1:25),:);

centroidsSort = sortrows(centroids,1);
for ii = 1:5
    centroidsSort(((ii-1)*5+1):(ii*5),:) = sortrows(centroidsSort(((ii-1)*5+1):(ii*5),:),2);
end

homography = fitHomography(centroidsSort', projectorCentroids);

fprintf('Projector calibrated.\n');
set(h_display,'cdata',displayImage);

% Wall Calibration
preview(wallcam)
for n=1:calib_skip
    frame = getdata(vid);
    wallFrame = getdata(wallcam);
    flushdata(vid)
    flushdata(wallcam)
end
flushdata(vid)
flushdata(wallcam)
for n=1:calib_iters
    frame = getdata(vid);
    wallFrame = getdata(wallcam);
    diff = (double(wallFrame) - double(backgroundWall)).^2;
    dist = diff(:,:,3) + diff(:,:,2);
    finger = (dist > 40);
    y = getWallIntersection(finger);
    wallBoundary = wallBoundary + y + 30;
    flushdata(vid)
    flushdata(wallcam)
end
wallBoundary = round(wallBoundary / calib_iters);
closepreview(wallcam)
flushdata(vid)
flushdata(wallcam)
fprintf('Wall calibrated.\n')