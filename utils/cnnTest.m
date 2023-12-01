%Function that tests the CNN model.
function [sens_pred_1, spec_pred_1, sens_det_1, spec_det_1,sens_pred_2, spec_pred_2, sens_det_2, spec_det_2] = cnnTest(patient,model)
    
    file = "../models/classifiers/"+model; 
    load(file,"net");
    if(patient == 1)           
        load '../dataset/44202.mat' FeatVectSel Trg
    elseif(patient == 2)
        load '../dataset/63502.mat' FeatVectSel Trg 
    end
    P = FeatVectSel;
    T = Trg;
    % Divinding the dataset and target into treino + test
    [~,data_test,~,target_test] = divideDataset(P,T ,0.85);
    
    target_test = correctTarget(target_test);
    
    % INVERTING P AND T
    data_test = data_test';
    target_test = target_test';

    [data_4D_test, target_4D_test] = ccn_pre_processing(data_test,  target_test);

    result = classify(net, data_4D_test);
    
    target = grp2idx(target_4D_test)';
    result = grp2idx(result)';
    
    [sens_pred_1, spec_pred_1, sens_det_1, spec_det_1] = confMatrix(result, target);
    [sens_pred_2, spec_pred_2, sens_det_2, spec_det_2] = postProcessing(result, target);
    
end