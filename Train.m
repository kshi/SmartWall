cellSize = 8;
posFeatures = zeros(size(pos,4),(160/cellSize-1) * (160/cellSize-1) * 36);
for n=1:size(pos,4)
    posRescaled = imresize(pos(:,:,:,n),0.5);
    posFeatures = extractHOGFeatures(posRescaled);
end

negFeatures = zeros((size(neg,1) - 160)/10 * (size(neg,2)-160)/10 * size(neg,4),(160/cellSize-1) * (160/cellSize - 1) * 36);

for n=1:size(neg,4)
    for x=1:(size(neg,2)-160)/10
        for y=1:(size(neg,1)-160)/10
		
            
            
        end
    end
end
