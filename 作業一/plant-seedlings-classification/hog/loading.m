 function[trainMatrix, testMatrix, trainBelong, testBelong] = loading()
trainMatrix = [];    % store every training file in a column
testMatrix = [];    % store every test file in a column
trainBelong = [];    % each training file belong to whom
testBelong = [];    % each test file belong to whom

rootFolder = fullfile('..\train\');
%rootFolder_t = fullfile('C:\Users\User\Documents\大四下\電腦視覺\作業一\plant-seedlings-classification\test\');
species = {'Black-grass','Charlock','Cleavers','Common Chickweed','Common wheat','Fat Hen','Loose Silky-bent','Maize','Scentless Mayweed','Shepherds Purse','Small-flowered Cranesbill','Sugar beet'};
imds = imageDatastore(fullfile(rootFolder, species), 'LabelSource', 'foldernames');
%imds_t = imageDatastore(fullfile(rootFolder_t));
tbl = countEachLabel(imds)

MyFolderInfo = dir('..\train');
cd ..\
cd .\train
for i = 1:12
    
    n_folder=i+2;
    son_folder=MyFolderInfo(n_folder).name;
    %     son_folder=string(species(i).name);
    %image_folder = fullfile('.\train', son_folder);
    image_folder = fullfile( son_folder);
    %image_folder = fullfile('.\train',species(i)); %  Enter name of folder from which you want to upload pictures with full path
    image_folder= string(image_folder);
    filenames = dir(fullfile(image_folder, '*.png'));  % read all images with specified extention, its jpg in our case
    total_images = numel(filenames);    % count total number of photos present in that folder
    half=total_images/2;
    cd(image_folder);
    
    for j = 1:round(half)    % for training
        img = imread(filenames(j).name);
        %featureVector = encode(bag, img);% vector with 1*500
        [featureVector,hogVisualization] = extractHOGFeatures(img);
        trainMatrix = [trainMatrix featureVector(:)];    % add data to matrix
        trainBelong = [trainBelong i];
    end
    for j = (round(half)+1):total_images    % other pictures for testing
        img = imread(filenames(j).name);
        %featureVector = encode(bag, img);% vector with 1*500
        [featureVector,hogVisualization] = extractHOGFeatures(img);
        testMatrix = [testMatrix featureVector(:)];    % add data to matrix
        testBelong = [testBelong i];
    end
    cd ..\
end% for i loop
cd ..
end% for function

