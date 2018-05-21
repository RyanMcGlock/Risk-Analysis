function StockLogReturns = computeStockLogReturns(StockPrices)
    
    for i=2:length(StockPrices)
        VZlogreturns(i-1) = log(StockPrices(i,1)/StockPrices(i-1,1));
        INTClogreturns(i-1) = log(StockPrices(i,2)/StockPrices(i-1,2));
        JPMlogreturns(i-1) = log(StockPrices(i,3)/StockPrices(i-1,3));
        APPLlogreturns(i-1) = log(StockPrices(i,4)/StockPrices(i-1,4));
        MSFTlogreturns(i-1) = log(StockPrices(i,5)/StockPrices(i-1,5));
        PGlogreturns(i-1) = log(StockPrices(i,6)/StockPrices(i-1,6));
    end
    
    StockLogReturns = [VZlogreturns', ...
                       INTClogreturns', ...
                       JPMlogreturns', ...
                       APPLlogreturns', ...
                       MSFTlogreturns', ...
                       PGlogreturns'];
end