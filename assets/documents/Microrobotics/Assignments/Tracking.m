clear all; clc; close all

startframe = 1;
endframe = 1001;
fov = [0 0 720 720];
i = 0;
moviename = strcat(['Tracking.avi']);
writerObj = VideoWriter(moviename);
writerObj.FrameRate = 10;
writerObj.Quality = 95;
open(writerObj);

for F = startframe:1:endframe
    i = i+1
    [Img,Img_crop] = loadvideo('25um_GOOODclock_50fps_1000Frames_3.mp4',F,fov);
    [BW,STATS] = binarytracking(Img_crop,0.6,1,1,1,5000,1000000,1);   
    c(i,:) = STATS.Centroid;
    imshow(Img_crop)
    hold on
    trajectory_length = 50000;
    if i < trajectory_length+1
        plot(c(1:i,1),c(1:i,2),'-r','linewidth',10)
    else
        plot(c(i-trajectory_length:i,1),c(i-trajectory_length:i,2),'-r','linewidth',10)
    end
    
    scalebar = 10; % um
    pixel_dist = 0.17;
    line([fov(3)-20-scalebar/pixel_dist fov(3)-20],...
        [fov(4)-7 fov(4)-7],...
        'linewidth',5,'color','black')
    text(fov(3)-22-scalebar/pixel_dist,...
        fov(4)-19,...
        [num2str(scalebar) ' \mum'],...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'middle',...
        'color','black','fontsize',10,'FontWeight','bold');

    hold off
    frame = getframe(gca);
    writeVideo(writerObj,frame);
end
close(writerObj)

