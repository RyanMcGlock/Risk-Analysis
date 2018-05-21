function ExpectedShortfall = ES(VaRlogreturns, HistVaR)
    count=0; SumReturns=0;
    for i=1:length(VaRlogreturns)
        if VaRlogreturns(i)<= HistVaR
            SumReturns = SumReturns + VaRlogreturns(i);
            count = count+1;
        end
    end
    ExpectedShortfall = SumReturns/count;
end