function [ x,y ] = detectFingerTip( person, direction )

CC = bwconncomp(person,8);
numPixels = cellfun(@numel, CC.PixelIdxList);
[~,idx] = max(numPixels);
[Y,X] = ind2sub(CC.ImageSize,CC.PixelIdxList{idx});

if strcmp(direction,'right')
    [~,RHS] = max(X);

    far = abs(X - X(RHS)) > 50;
    Y(far) = [];
    X(far) = [];
    [~,pointId] = min(Y);

    y = Y(pointId);
    x = X(pointId);

elseif strcmp(direction,'down')
    [~,RHS] = max(Y);

    far = abs(Y - Y(RHS)) > 50;
    Y(far) = [];
    X(far) = [];
    [~,pointId] = max(X);

    y = Y(pointId);
    x = X(pointId);
else
    fprintf('Direction not supported. Enter right or down. \n')
    x = -1;
    y = -1;
end
        
end

