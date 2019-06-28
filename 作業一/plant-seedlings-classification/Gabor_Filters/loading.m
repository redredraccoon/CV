function[trainMatrix, testMatrix, trainBelong, testBelong] = loading()
trainMatrix = [];    % store every training file in a column
testMatrix = [];    % store every test file in a column
trainBelong = [];    % each training file belong to whom
testBelong = [];    % each test file belong to whom

rootFolder = fullfile('..\train\');
species = {'Black-grass','Charlock','Cleavers','Common Chickweed','Common wheat','Fat Hen','Loose Silky-bent','Maize','Scentless Mayweed','Shepherds Purse','Small-flowered Cranesbill','Sugar beet'};
imds = imageDatastore(fullfile(rootFolder, species), 'LabelSource', 'foldernames');
tbl = countEachLabel(imds)
gaborArray = gaborFilterBank(5,8,39,39);  % Generates the Gabor filter bank
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
    image_folder
    for j = 1:round(half)    % for training
        
        img = imread(filenames(j).name);
        filenames(j).name
        %featureVector = gaborFeatures(img,gaborArray,4,4);
        if size(img,3) == 3     % Check if the input image is grayscale
            warning('The input RGB image is converted to grayscale!')
            img = rgb2gray(img);
        end
        
        img = double(img);
        
        
        %% Filter the image using the Gabor filter bank
        
        % Filter input image by each Gabor filter
        [u,v] = size(gaborArray);
        gaborResult = cell(u,v);
        for h = 1:u
            for z = 1:v
                gaborResult{h,z} = imfilter(img, gaborArray{h,z});
            end
        end
        
        
        %% Create feature vector
        
        % Extract feature vector from input image
        featureVector = [];
        for h = 1:u
            for z = 1:v
                
                gaborAbs = abs(gaborResult{h,z});
                gaborAbs = downsample(gaborAbs,56);
                gaborAbs = downsample(gaborAbs.',4);
                gaborAbs = gaborAbs(:);
                
                % Normalized to zero mean and unit variance. (if not applicable, please comment this line)
                gaborAbs = (gaborAbs-mean(gaborAbs))/std(gaborAbs,1);
                
                featureVector =  [featureVector; gaborAbs];
                
            end
        end
        
        trainMatrix = [trainMatrix featureVector];    % add data to matrix
        trainBelong = [trainBelong i];
    end% for j
    for j = (round(half)+1):total_images    % other pictures for testing
        img = imread(filenames(j).name);
        filenames(j).name
        %featureVector = gaborFeatures(img,gaborArray,4,4);
        
        if size(img,3) == 3     % Check if the input image is grayscale
            warning('The input RGB image is converted to grayscale!')
            img = rgb2gray(img);
        end
        
        img = double(img);
        
        
        %% Filter the image using the Gabor filter bank
        
        % Filter input image by each Gabor filter
        [u,v] = size(gaborArray);
        gaborResult = cell(u,v);
        for h = 1:u
            for z = 1:v
                gaborResult{h,z} = imfilter(img, gaborArray{h,z});
            end
        end
        
        
        %% Create feature vector
        
        % Extract feature vector from input image
        featureVector = [];
        for h = 1:u
            for z = 1:v
                
                gaborAbs = abs(gaborResult{h,z});
                gaborAbs = downsample(gaborAbs,56);
                gaborAbs = downsample(gaborAbs.',4);
                gaborAbs = gaborAbs(:);
                
                % Normalized to zero mean and unit variance. (if not applicable, please comment this line)
                gaborAbs = (gaborAbs-mean(gaborAbs))/std(gaborAbs,1);
                
                featureVector =  [featureVector; gaborAbs];
                
            end
        end
        
        testMatrix = [testMatrix featureVector];    % add data to matrix
        testBelong = [testBelong i];
    end% for j
    cd ..\
end% for i loop
cd ..
end% for function