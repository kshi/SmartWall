function [ z ] = getWallIntersection( pointer )

    CC = bwconncomp(pointer,8);
    numPixels = cellfun(@numel, CC.PixelIdxList);
    [~,idx] = max(numPixels);
    [~,X] = ind2sub(CC.ImageSize,CC.PixelIdxList{idx});
    z = min(X);

end

