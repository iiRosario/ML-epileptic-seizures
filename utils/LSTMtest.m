%This functions as the "loadModel" and "cnnTest" is used to test the LSTM
%models trained by the "LSTM" function.
function [sens_pred_1, spec_pred_1, sens_det_1, spec_det_1,sens_pred_2, spec_pred_2, sens_det_2, spec_det_2] = LSTMtest(patient,model)
    
       file = "../models/classifiers/"+model; 
    load(file,"net");

     % Choosing patient A or B
    if(patient == 1)
        load '../dataset/44202.mat' FeatVectSel Trg
    elseif(patient == 2)
        load '../dataset/63502.mat' FeatVectSel Trg
    end

    XTrain=FeatVectSel;
    YTrain=correctTarget2(Trg);
    % YTrain=T;

    percentage = 0.85;
    
    breakingIndex = round(length(XTrain) * percentage);
    data_test = XTrain(breakingIndex+1:end , :);
    
    target_test = YTrain(breakingIndex+1:end , :);
    
    data_test=num2cell(data_test',1);
  
    target_test=categorical(target_test);

    result = classify(net, data_test);
     
    target = grp2idx(target_test)';
    result = grp2idx(result)';


    [sens_pred_1, spec_pred_1, sens_det_1, spec_det_1] = confMatrix(result, target);
    [sens_pred_2, spec_pred_2, sens_det_2, spec_det_2] = postProcessing(result, target);