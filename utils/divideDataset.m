%This function divides the data set into two, the size of each part is
%determined by the "value" argument. Notice that for this project the value
%used to train and test every model was 85% train and 15% test.

function [data_treino,data_test,target_treino,target_test] = divideDataset(P,T ,value)
    % Divinding the dataset and target into treino + test
    percentage = value;
    
    breakingIndex = round(length(P) * percentage);
    
    data_treino = P(1:breakingIndex, :);
    data_test = P(breakingIndex+1:end , :);
    target_treino = T(1:breakingIndex, :);
    target_test = T(breakingIndex+1:end , :);

end