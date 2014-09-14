function [ density ] = computeDensity( person, x, y )

CC = bwconncomp(person,8);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);
strip = uint8(zeros(CC.ImageSize));
strip(:, max(x-100,1):x) = 8;
detections = uint8(zeros(CC.ImageSize));
detections(CC.PixelIdxList{idx}) = 8;
detections = detections .* strip;
detections(max(y-5,1):min(y+5,720), max(x-5,1):min(x+5,1280)) = 256;

localPatch = detections(max(y-20,1):min(y+20,720), max(x-20,1):min(x+20,1280)) > 0;
density = sum(localPatch(:)) / numel(localPatch(:));

end

