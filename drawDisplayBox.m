function [ M ] = drawDisplayBox( M, x, y )

xmax = size(M,2);
ymax = size(M,1);
M( max(y-5,1):min(y+5,ymax), max(x-5,1):min(x+5,xmax) ) = 256;

end

