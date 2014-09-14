function im = uvcCamIm()

    rawIm = [];
    while isempty(rawIm)
        rawIm = uvcCam('read');
    end
    while ~isempty(rawIm)
        rawIm2 = rawIm;
        rawIm = uvcCam('read');
    end
    im = mexFull(rawIm2);
    
end