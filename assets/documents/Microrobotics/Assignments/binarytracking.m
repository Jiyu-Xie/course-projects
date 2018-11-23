function [BW, STATS] = binarytracking(Img_crop,level,invert,fill,border,filter_small,filter_large,largest)

%% invert image
if invert == 1
    BW = 1-im2bw(Img_crop,level);
elseif invert == 0
    BW = im2bw(Img_crop,level);
end

%% fill hole
if fill == 1
    BW = imfill(BW,'hole');
elseif fill == 0
end

%% remove border objects
if border == 1
BW = imclearborder(BW);
elseif border == 0
end

%% filter small
BW = bwareaopen(BW,filter_small);

%% filter large
[L,num]=bwlabel(BW,8);
if num > 0
for i=1: num
    blocksize(i)=length(find(L==i));
end
[C,I] = find(blocksize > filter_large);
TF = isempty(I);
if TF == 0
    for i = 1:length(I)
        BW(find(L==I(i))) = 0;
    end
elseif TF == 1
end
end

%% choose largest
if num > 0
if largest == 1
    [L,num]=bwlabel(BW,8);
    for i=1: num
        blocksize(i)=length(find(L==i));
    end
    [C,I] = max(blocksize);
    BW = zeros(size(BW));
    BW(find(L==I)) = 1;
elseif largest == 0
end
end

%% output
STATS = regionprops(BW,'centroid','orientation','area','MajorAxisLength','MinorAxisLength','Extrema','Eccentricity');

