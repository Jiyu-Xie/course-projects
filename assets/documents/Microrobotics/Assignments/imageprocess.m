% 'orientstats' determines statistics on blotting patterns

I = imread('bargeleft.jpg');
figure(1); imshow(I);

level = 0.5;
bw = im2bw(I,level);
figure(2); imshow(bw);

bwinv = 1-bw;
figure(3); imshow(bwinv);

bwthresh1 = sizethre(1-bw,15,'down');
figure(4); imshow(bwthresh1);

bwthresh = sizethre(bwthresh1,150,'up');
figure(5); imshow(bwthresh);

L = bwlabel(bwthresh);

a = regionprops(L,'area');
bactarea = cat(1, a.Area);
hist(bactarea)
ylabel('total bacteria')

c = regionprops(L,'orientation');
bactorient = cat(1, c.Orientation);
hist(bactorient)
xlabel('angle in degrees')
ylabel('total bacteria')



