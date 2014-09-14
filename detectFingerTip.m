function [ x,y ] = detectFingerTip( person )

CC = bwconncomp(person,8);
numPixels = cellfun(@numel, CC.PixelIdxList);
[~,idx] = max(numPixels);
[Y,X] = ind2sub(CC.ImageSize,CC.PixelIdxList{idx});

[~,RHS] = max(X);

far = abs(X - X(RHS)) > 50;
Y(far) = [];
X(far) = [];
[~,pointId] = min(Y);

y = Y(pointId);
x = X(pointId);
        
end

