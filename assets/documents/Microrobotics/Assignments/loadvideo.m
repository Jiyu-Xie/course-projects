function [Img,Img_crop] = loadvideo(videoname,F,fov)

vid = VideoReader(videoname);
I = read(vid, F);
Img = I;
I = imcrop(I,fov);
Img_crop = I;

