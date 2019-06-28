clc;
clear;
[trainMatrix, testMatrix, trainBelong, testBelong] = loading();
[row, trainCount] = size(trainMatrix);
[row, testCount] = size(testMatrix);
correctSAD = 0;
Species = {'Black-grass','Charlock','Cleavers','Common Chickweed','Common wheat','Fat Hen','Loose Silky-bent','Maize','Scentless Mayweed','Shepherds Purse','Small-flowered Cranesbill','Sugar beet'};

for test = 1:testCount
    distance = [];
    for train = 1:trainCount
        distance(:,train) = testMatrix(:,test) - trainMatrix(:,train);  % find distance between two picture
    end
    
    SAD = sum(abs(distance));   % calculate SAD
    [value, index] = min(SAD);  % find the min SAD
       
    if testBelong(test) == trainBelong(index)   % belong to the same person
        correctSAD = correctSAD+1;
    end
end
fprintf('SAD : %f%%\n', correctSAD/testCount*100);
