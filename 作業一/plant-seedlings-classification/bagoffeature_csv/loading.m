function[trainMatrix, testMatrix, trainBelong, testBelong] = loading()
trainMatrix = [];    % store every training file in a column
testMatrix = [];    % store every test file in a column
trainBelong = [];    % each training file belong to whom
testBelong = [];    % each test file belong to whom

rootFolder = fullfile('..\train\');
%rootFolder_t = fullfile('..\test\');
species = {'Black-grass','Charlock','Cleavers','Common Chickweed','Common wheat','Fat Hen','Loose Silky-bent','Maize','Scentless Mayweed','Shepherds Purse','Small-flowered Cranesbill','Sugar beet'};
imds = imageDatastore(fullfile(rootFolder, species), 'LabelSource', 'foldernames');
imds_t = imageDatastore(fullfile(rootFolder_t));
tbl = countEachLabel(imds)

%[trainingSet, validationSet] = splitEachLabel(imds, 0.5, 'randomize');%Separate the sets into training and validation data.

bag = bagOfFeatures(imds);
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
    cd(image_folder);
    image_folder
    for j = 1:total_images    % for training
        img = imread(filenames(j).name);
        featureVector = encode(bag, img);% vector with 1*500
        
        trainMatrix = [trainMatrix featureVector(:)];    % add data to matrix
        trainBelong = [trainBelong i];
    end
    %     for j = 1:794    % other pictures for testing
    %         img = readimage(imds_t, j);
    %         featureVector = encode(bag, img);% vector with 1*500
    %
    %         testMatrix = [testMatrix featureVector(:)];    % add data to matrix
    %         testBelong = [testBelong i];
    %     end
    cd ..\
end
cd ..
rootFolder_t = fullfile('.\test\');
imds_t = imageDatastore(fullfile(rootFolder_t));
for k = 1:794    % other pictures for testing
    img = readimage(imds_t, k);
    featureVector = encode(bag, img);% vector with 1*500
    
    testMatrix = [testMatrix featureVector(:)];    % add data to matrix
    %testBelong = [testBelong i];
end

end