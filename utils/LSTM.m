%This function was used to train the LSTM models.

function [sens_pred_1, spec_pred_1, sens_det_1, spec_det_1,sens_pred_2, spec_pred_2, sens_det_2, spec_det_2] = LSTM(patient, hasBalance, hasEnconding, numHiddenUnits, maxEphocs)
    numFeatures=29;
    
    % Choosing patient A or B
    if(patient == 1)
        load '../dataset/44202.mat' FeatVectSel Trg
    elseif(patient == 2)
        load '../dataset/63502.mat' FeatVectSel Trg
    end
    P = FeatVectSel;
    T = correctTarget2(Trg);
    
     %Has Auto-enconders
    if(hasEnconding)
        if(patient == 1)
            load '../models/autocoender/autoCoender44202.mat' auto
        elseif(patient == 2)
            load '../models/autocoender/autoCoender63502.mat' auto
        end
        P = predict(auto,P);
    end

    % Divinding the dataset and target into treino + test
    [data_treino,data_test,target_treino,target_test] = divideDataset(P,T ,0.85);

    % INVERTING P AND T
    data_treino = data_treino';
    target_treino = target_treino';
    data_test = data_test';
    target_test = target_test';

    
    %balacing train
    if(hasBalance == 1)
        [data_treino, target_treino] = balanceTrainSet(data_treino, target_treino);  
    end
   
   
    data_treino=num2cell(data_treino,1);
   
    target_treino=categorical(target_treino);

    numClasses=3;
    
    layers=[
        sequenceInputLayer(numFeatures)
        lstmLayer(numHiddenUnits,'OutputMode','last')
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer

    ];
    options=trainingOptions('adam', ...
        'MaxEpochs',maxEphocs,...
        'GradientThreshold',1,...
        'InitialLearnRate',0.005,...
        'LearnRateDropFactor',0.2, ...
        'Verbose',0, ...
        'Plots','training-progress');
    net=trainNetwork(data_treino , target_treino,layers,options);

    save("custom","net");
    
    data_test=num2cell(data_test,1);
  
    target_test=categorical(target_test);

    result = classify(net, data_test);
     
    target = grp2idx(target_test)';
    result = grp2idx(result)';


    [sens_pred_1, spec_pred_1, sens_det_1, spec_det_1] = confMatrix(result, target);
    [sens_pred_2, spec_pred_2, sens_det_2, spec_det_2]=postProcessing(result, target);

end