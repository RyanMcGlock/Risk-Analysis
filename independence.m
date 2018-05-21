function [LRind, outcomeLRind, LRcc, outcomeRCC] = independence(VaR, violations, Kupiec)
    T00 =0;T01 =0;T10 =0;T11 =0;
    for i=1:(length(violations)-1)
        if violations(i)==1
            if violations(i+1)==1
                T11 = T11 + 1;
            else
                T10 = T10 +1;
            end
        end    
        if violations(i)==0
            if violations(i+1)==1
                T01 = T01 +1;
            else
                T00 = T00 +1;
            end    
        end
    end
    Lpi = ((1-(sum(violations)/length(VaR)))^(length(VaR)-sum(violations)))*...
          ((sum(violations)/length(VaR))^sum(violations));
    pi01 = T01/(T00+T01);
    pi11 = T11/(T10+T11);
    Lpi1 = ((1-pi01)^T00)*(pi01^T01)*((1-pi11)^T10)*(pi11^T11);
    LRind = -2*log(Lpi/Lpi1);
    chisq = icdf('chi2',0.95,1);
    if chisq>LRind
        outcomeLRind='Calibrated';
    else outcomeLRind='NotCalibrated';
    end
   
    LRcc = Kupiec + LRind;
    chisq = icdf('chi2',0.95,2);
    if chisq>LRcc
        outcomeRCC='Calibrated';
    else outcomeRCC='NotCalibrated';
    end
end