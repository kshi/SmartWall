circles = magYCbCrDiff>0.1;
circles = imopen(circles,ones(5));
blobs = bwconncomp(circles,8);
centroids = regionprops(blobs,'Centroid');
centroids = cat(1,centroids.Centroid);

centroidsSort = sortrows(centroids,1);
for ii = 1:8
    centroidsSort(((ii-1)*6+1):(ii*6),:) = sortrows(centroidsSort(((ii-1)*6+1):(ii*6),:),2);
end

%http://www.mathworks.com/matlabcentral/answers/26141-homography-matrix
% Solve equations using SVD
x = centroidsSort(:,1)'; y = centroidsSort(:,2)'; X = centroidsX'; Y = centroidsY';
n = length(x);
rows0 = zeros(3, n);
rowsXY = -[X; Y; ones(1,n)];
hx = [rowsXY; rows0; x.*X; x.*Y; x];
hy = [rows0; rowsXY; y.*X; y.*Y; y];
h = [hx hy];
if n == 4
    [U, ~, ~] = svd(h);
else
    [U, ~, ~] = svd(h, 'econ');
end
v = (reshape(U(:,9), 3, 3)).';

v = v./v(3,3);

figure(1)
clf
plot(x,y,'*r'); hold on;
mapped = v*[X;Y;ones(1,n)];
plot(mapped(1,:),mapped(2,:),'.b')