function [ x,y ] = detectFingerTip( CC )

numPixels = cellfun(@numel, CC.PixelIdxList);
large = find(numPixels > 2*std(numPixels));

if length(large) > 0    
    rightmost = zeros(1,length(large));
    for n=1:length(large)
        [~,X] = ind2sub(CC.ImageSize,CC.PixelIdxList{large(n)});
        rightmost(n) = max(X);
    end
    [~,idx] = max(rightmost);
    [Y,X] = ind2sub(CC.ImageSize,CC.PixelIdxList{large(idx)});

    [~,RHS] = max(X);

    far = abs(X - X(RHS)) > 50;
    Y(far) = [];
    X(far) = [];
    [~,pointId] = min(Y);

    y = Y(pointId);
    x = X(pointId);
else
    x = 0;
    y = 0;
end
end