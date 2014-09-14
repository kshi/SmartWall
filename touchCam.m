% Camera initialization
addpath uvcCam
uvcCam('init','/dev/video1');
uvcCam('stream_on');

% Background Calibration
backgroundRGB = zeros(480,640,3);
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
backgroundRGB = backgroundRGB./calib_iters;

% Touch Calibration
touchCalib = 0;
touchCntr = 0;
wallBoundary = 640;

% Plotting
figure(1)
set(gcf,'buttondownfcn','touchCalib = 1; tic;');

magDiff = zeros(480,640);
person = zeros(480,640);

subplot(121)
h_magDiff = imshow(magDiff);

subplot(122)
h_person = imshow(person);
hold on
h_wall = plot([wallBoundary,wallBoundary],[0,480]);
hold off

while(1)
    % Get new frame
    imRaw = uvcCamIm();
    imYCbCr = double(imRaw)./255;
    
    rawYCbCrDiff = imYCbCr - backgroundYCbCr;
    magYCbCrDiff = ...
        sqrt(0.*rawYCbCrDiff(:,:,1).^2 + ...
        rawYCbCrDiff(:,:,2).^2 + rawYCbCrDiff(:,:,3).^2);
    
    magDiff = magYCbCrDiff;
    set(h_magDiff,'cdata',magDiff);
    
    person = imclose(magDiff > 0.08,ones(4));
    set(h_person,'cdata',person);
    
    
    % Touch Calibration
    if touchCalib
        if toc < 10
            title(toc);
            [ys,xs] = find(imopen(person,ones(4)));
            if ~isempty(ys)
                wallBoundary = min(wallBoundary, min(xs));
                set(h_wall,'xdata',[wallBoundary,wallBoundary]);
            end
        else
            touchCalib = 0;
            wallBoundary = wallBoundary + 10;
        end
    end
    
    % Detect Touch
    if wallBoundary < 640
        [ys,xs] = find(person);
        if min(xs) < wallBoundary
            title('TOUCH')
        else
            title('')
        end
    end
    
    drawnow
end