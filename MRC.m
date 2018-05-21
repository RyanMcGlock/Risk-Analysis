function MRC = MRC(alpha, starty, logreturns)
    z = norminv(1-alpha);
    tendayAvg=0;
    for i=1:60
        tendayAvg = tendayAvg -z*sqrt(10)*std(logreturns(length(logreturns)-60-250+(i-1):length(logreturns)-60+(i-1)));
    end

    for i=0:(length(logreturns)-starty-1)
        GaussianVaRMRC(i+1,:) = GaussVaR(logreturns((starty-250)+i:starty+i),alpha);
    end
    
    countMRC=0;
    %%%Need to get the amount of outliers to gain St factor
    for i=0:250
        if logreturns(length(logreturns)-250+i)<-GaussianVaRMRC(length(GaussianVaRMRC)-250+i,1)
            countMRC=countMRC+1;
        end
    end
    
    tendayst = std(logreturns)*sqrt(10);
    S=1.76; %Got from Table 2 of question 6.
    MRC = max(tendayst, tendayAvg*S/60);
end