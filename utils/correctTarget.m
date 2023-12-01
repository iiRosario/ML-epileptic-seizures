%This function is used to transform the given target to a more adequate
%one. This first function turns the target vector into a 3 collum matrix,
%where, the position of the number 1 determines the state of the patient at
%that momment.
function  resultado= correctTarget(T)
    result = [ones(length(T),1) zeros(length(T),1) zeros(length(T),1)];
    controle = [];
    valido=1;
    for i=1:length(T)
        if(T(i)==1 && valido)
            controle=[controle i];
            valido=0;
        else if(T(i)==0 & ~valido)
            controle=[controle i];
            valido=1;
        end
        end
    end
    
    for i = 1:2:length(controle)
        result(controle(i)-300:controle(i)-1 , 2) = 1;
        result(controle(i) : controle(i+1)+60 , 3) = 1;
        result(controle(i)-300 : controle(i+1)+60 , 1) = 0;
    end
    
    
    count = 0;
    for k = 1:length(result)
        if(result(k,3) == 1)
            count = count +1;
        end
    end
    resultado=result;
end