%This function is used balance the data set in a way that we have as much
%interictal points as pre-ictal and ictal points. The function balance the
%data set by determining the difference between the interictal points and
%the sum of the pre-ictal and ictal points, them it generates a random
%index list of the interictal points that will be maintained.

function [novo_p,novo_t] = balanceTrainSet(P, T_corrigido)
        lengthResultado = sum(T_corrigido(:,1))-(sum(T_corrigido(:,2)) + sum(T_corrigido(:,3)));
        index = find(T_corrigido(:,1));
        index(randperm(length(index)));
        index=index(1:lengthResultado);
        T_corrigido(index,:)=[];
        P(index,:)=[];
        novo_p=P;
        novo_t=T_corrigido;
end