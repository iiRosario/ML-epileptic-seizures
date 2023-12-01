%This function is used to process the results of every matrix in an attempt
%to better the results. The way this function works is by getting rid of
%outlier points, so, for example, in a pre-ictal phase the model might
%generate singular points of interictal phase (ie. [2 2 2 2 2 2 1 2 2 2])
%which are deleted (ie.[2 2 2 2 2 2 2 2 2]).
function [sens_pred, spec_pred, sens_det, spec_det]= postProcessing(result, target)
    
    indexes = [];
    count = [0 0 0];
    for i = 1:10:length(result)-10
        count(1) = nnz(find(result(i:i+9) == 1));
        count(2) = nnz(find(result(i:i+9) == 2));
        count(3) = nnz(find(result(i:i+9) == 3));
        
        [max_count, index_count] = max(count);
        
        if(max_count >= 5)
             for j = i:i+9
                if(result(j) == index_count)
                    indexes = [indexes j];
                end
            end
        end
      
    end

    result = result(indexes);
    target = target(indexes);
    [sens_pred, spec_pred, sens_det, spec_det] = confMatrix(result, target);
end