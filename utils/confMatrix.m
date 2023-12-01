%This function compares the result of the model with the target resolution
%and returns the confusion matrix as well as the results for the
%specificity and sensitivity.
function [sens_pred, spec_pred, sens_det, spec_det] = confMatrix(result, target)
    
    conf_matrix = confusionmat(target,result);
    confusionchart(conf_matrix)
    
    TP_predict=conf_matrix(2,2);
    FN_predict=conf_matrix(2,1) + conf_matrix(2,3);
    FP_predict=conf_matrix(1,2) + conf_matrix(3,2);
    TN_predict=conf_matrix(1,1) + conf_matrix(3,3);

    TP_detection=conf_matrix(3,3);
    FN_detection= conf_matrix(3,1) + conf_matrix(3,2);
    FP_detection= conf_matrix(1,3) + conf_matrix(2,3);
    TN_detection= conf_matrix(1,1) + conf_matrix(2,2);

    sens_pred = TP_predict/(TP_predict+FN_predict);
    spec_pred = TN_predict/(TN_predict+FP_predict);

    sens_det = TP_detection/(TP_detection+FN_detection);
    spec_det = TN_detection/(TN_detection+FP_detection);
end