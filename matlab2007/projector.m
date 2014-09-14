% Camera initialization
addpath uvcCam
uvcCam('init','/dev/video0');
uvcCam('stream_on');


% Plotting
width = 400;
height = 300;
dotSize = 15;
dot = [dotSize*cos(0:0.05:(2*pi));dotSize*sin(0:0.05:(2*pi))];

figure(1)
clf
set(gcf,'color',[0,0,0])
set(gca,'color',[0,0,0],'position',[0,0,1,1])
axis equal
set(gca,'xlim',[0,width],'ylim',[0,height])
drawnow
%h_patch = patch(-dotSize+dot(1,:),-dotSize+dot(2,:),[1,1,1]);

% Background Calibration
backgroundYCbCr = zeros(480,640,3);
calib_iters = 50;

for ii = 1:calib_iters
    imRaw = uvcCamIm();
end
for ii = 1:calib_iters
    imRaw = uvcCamIm();
    imYCbCr = double(imRaw)./255;
    backgroundYCbCr = backgroundYCbCr + double(imYCbCr);
    backgroundRGB = backgroundRGB + double(ycbcr2rgb(imYCbCr));
end
backgroundYCbCr = backgroundYCbCr./calib_iters;

% Record Calibration Image
%{
calibIm = zeros(height,width);
calibIm(mod(0:(height-51),100)<=50,mod(0:(width-51),100)<=50) = 1;
calibIm(mod(0:(height-51),100)>50,mod(0:(width-51),100)>50) = 1;

cornersx = 1:50:(width-49);
cornersy = 1:50:(height-49);
[cornersx, cornersy] = meshgrid(cornersx,cornersy);
cornersx = reshape(cornersx,[numel(cornersx),1]);
cornersy = reshape(cornersy,[numel(cornersy),1]);

imshow(calibIm)
drawnow
%}

for ii = 25:50:375
    for jj = 25:50:275
        patch(dot(1,:) + ii, dot(2,:) + jj, [1,1,1]);
    end
end
centroidsX = 25:50:375;
centroidsY = 25:50:275;
[centroidsX, centroidsY] = meshgrid(centroidsX,centroidsY);
centroidsX = reshape(centroidsX,[numel(centroidsX),1]);
centroidsY = reshape(centroidsY,[numel(centroidsY),1]);
drawnow


for ii = 1:calib_iters
    imRaw = uvcCamIm();
end

imRaw = uvcCamIm();
imYCbCr = double(imRaw)./255;

rawYCbCrDiff = imYCbCr - backgroundYCbCr;
magYCbCrDiff = sqrt(rawYCbCrDiff(:,:,1).^2);

circles = magYCbCrDiff>0.1;

save('for2012')
   