function [HistoricalVaR, HistoricalES] = HistVaR(logreturns,nine)
    n=length(logreturns);
    per = nine*n;
    perfl = floor(per);
    perflpone = perfl +1;
    gamma = per-perfl;
    logreturnssorted = sort(logreturns);
    HistoricalVaR = (1-gamma)*logreturnssorted(perfl) + gamma*logreturnssorted(perflpone);
    

    HistoricalES = sum(logreturnssorted(1:perfl))/perfl;
end