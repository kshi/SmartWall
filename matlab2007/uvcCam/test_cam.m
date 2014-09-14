addpath( [ getenv('VIS_DIR') '/ipc' ] )
addpath ~/svn/kQuad/trunk/utils/

uvcCam('init','/dev/video0');
uvcCam('stream_on');
uvcCam('set_ctrl','contrast', 32);

cntr=0;

%{
host = 'localhost';
ipcAPIConnect(host);
imgMsgName = ['Robot1/Video0' VisMarshall('getMsgSuffix','ImageData')];
imgMsgFormat  = VisMarshall('getMsgFormat','ImageData');
ipcAPIDefine(imgMsgName,imgMsgFormat);
%}


while(1)
  pause(0.03);
  imYuyv = uvcCam('read');
  if ~isempty(imYuyv)
    cntr      = cntr + 1;
    imRgb     = yuyv2rgbm(imYuyv);
    image(imRgb);
    set(gca,'ydir','reverse','xdir','normal');
    drawnow;
    %content = VisMarshall('marshall','ImageData',imRgb);
    %ipcAPIPublishVC(imgMsgName,content);
  end
end
