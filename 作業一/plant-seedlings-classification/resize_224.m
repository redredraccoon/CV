rootFolder = fullfile('.\train\');
rootFolder_t = fullfile('.\test\');
species = {'Black-grass','Charlock','Cleavers','Common Chickweed','Common wheat','Fat Hen','Loose Silky-bent','Maize','Scentless Mayweed','Shepherds Purse','Small-flowered Cranesbill','Sugar beet'};
imds = imageDatastore(fullfile(rootFolder, species), 'LabelSource', 'foldernames');
imds_t = imageDatastore(fullfile(rootFolder_t));

%https://www.mathworks.com/matlabcentral/answers/363394-alter-and-store-images-back-into-an-excisting-imagedatastore
for i=1:4750
    [img, info] = readimage(imds, i);
    img=imresize(img, [224 224]);
    imwrite(img,info.Filename);
end

for i=1:794
    [img, info] = readimage(imds_t, i);
    img=imresize(img, [224 224]);
    imwrite(img,info.Filename);
end