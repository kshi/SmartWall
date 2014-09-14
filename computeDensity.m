function [ density ] = computeDensity( CC, x, y )

%CC = bwconncomp(person,8);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);
[Y,X] = ind2sub(CC.ImageSize, CC.PixelIdxList{idx});
density = sum((abs(Y - y) < 20) & (abs(X - x) < 20)) / 1600;

end

