%This function is used to change the dataset in a way that the neural
%network gives more importance to the pre-ictal and ictal phases.
function EW = errorWeights(target_treino)
    dimInter = nnz(find(all(target_treino==[1 0 0]'))); 
    dimPreictal = nnz(find(all(target_treino==[0 1 0]')));
    dimIctal = nnz(find(all(target_treino==[0 0 1]')));
    dimTotal = dimInter + dimPreictal + dimIctal;
    pInter = dimTotal/dimInter;
    pPre = dimTotal/dimPreictal;
    pIctal = dimTotal/dimIctal;
    EW = all(target_treino==[1 0 0]')*pInter + all(target_treino==[0 1 0]')*pPre + all(target_treino==[0 0 1]')*pIctal;
   
end