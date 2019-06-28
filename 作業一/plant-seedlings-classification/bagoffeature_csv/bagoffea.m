clc;
clear;
[trainMatrix, testMatrix, trainBelong, testBelong] = loading();
[row, trainCount] = size(trainMatrix);
[row, testCount] = size(testMatrix);
correctSAD = 0;
correctSSD = 0;
Species = {'Black-grass','Charlock','Cleavers','Common Chickweed','Common wheat','Fat Hen','Loose Silky-bent','Maize','Scentless Mayweed','Shepherds Purse','Small-flowered Cranesbill','Sugar beet'};
file = [];
species = [];
cd ..
image_folder = fullfile('.\test'); %  Enter name of folder from which you want to upload pictures with full path
image_folder= string(image_folder);
filenames = dir(fullfile(image_folder, '*.png'));  % read all images with specified extention, its jpg in our case
total_images = numel(filenames);    % count total number of photos present in that folder
cd(image_folder);
for test = 1:testCount
    distance = [];
    for train = 1:trainCount
        distance(:,train) = testMatrix(:,test) - trainMatrix(:,train);  % find distance between two picture
    end
    
    SAD = sum(abs(distance));   % calculate SAD
    [value, index] = min(SAD);  % find the min SAD
    
    file = [file string(filenames(test).name)];
    species = [species Species(trainBelong(index))];
    
%     if testBelong(test) == trainBelong(index)   % belong to the same person
%         correctSAD = correctSAD+1;
%     end
    
%     SSD = sum((distance).^2);   % calculate SSD
%     [value, index] = min(SSD);  % find the min SSD
%     if testBelong(test) == trainBelong(index)   % belong to the same person
%         correctSSD = correctSSD+1;
%     end
end
%fprintf('SAD : %f%%\nSSD : %f%%\n', correctSAD/testCount*100, correctSSD/testCount*100);
%fprintf('SAD : %f%%\n', correctSAD/testCount*100);
submission = table(file(:), species(:));
submission.Properties.VariableNames = {'file' 'species'};
writetable(submission,'..\submission_bag.csv');