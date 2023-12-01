
%This function was used to train the shallow networks that were used in
%this project.
function [sens_pred_1, spec_pred_1, sens_det_1, spec_det_1, sens_pred_2, spec_pred_2, sens_det_2, spec_det_2] = shallowClassify(patient,hasBalance, hasEW, hasEnconding, architeture, trainingStyle , ...
                                  trainFun, learnFun, numLayers, numHiddenNeurons, actFun1, actFun2, actFun3, hasSoftmax)
    % Choosing patient A or B
    if(patient == 1)
         load '../dataset/44202.mat' FeatVectSel Trg
    elseif(patient == 2)
         load '../dataset/63502.mat' FeatVectSel Trg
    end
    P = FeatVectSel;
    T = correctTarget(Trg);
    
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

    %Error weights
    if(hasEW == 1)
        EW = errorWeights(target_treino);
    end
    %-------------------- SHALLOW NETS -------------------- 
    if(architeture == 1 || architeture == 2)
        hiddenLayers = (1:numLayers);
        hiddenLayers(1,:) = numHiddenNeurons;
        
        if(architeture == 1)
            net = feedforwardnet(hiddenLayers , trainFun);
        elseif(architeture == 2)
            net = layrecnet(1:2 , hiddenLayers , trainFun);
        end
      
        if(trainingStyle == 1)
            net.adaptFcn = learnFun;
        end

        %activation 
        if(numLayers == 1)
            net.layers{1}.transferFcn = actFun1;
            if(hasSoftmax)
                net.layers{2}.transferFcn = "softmax";
            end
        elseif(numLayers == 2)
            net.layers{1}.transferFcn = actFun1;
            net.layers{2}.transferFcn = actFun2;
            if(hasSoftmax)
                net.layers{3}.transferFcn = "softmax";
            end
        elseif(numLayers == 3)
            net.layers{1}.transferFcn = actFun1;
            net.layers{2}.transferFcn = actFun2;
            net.layers{3}.transferFcn = actFun3;
            if(hasSoftmax)
                net.layers{4}.transferFcn = "softmax";
            end
        end
        
        net.trainParam.epochs = 1000;
        
        if(hasEW)
            net = train(net, data_treino,target_treino,[],[],EW);
        else
            net = train(net, data_treino,target_treino);
        end

        save("custom","net");
        result = net(data_test);
        view(net);
 
        [~,result] = max(result);
        [~,target_test] = max(target_test);
        [sens_pred_1, spec_pred_1, sens_det_1, spec_det_1] = confMatrix(result, target_test);
        [sens_pred_2, spec_pred_2, sens_det_2, spec_det_2]=postProcessing(result, target_test);

    end


end
