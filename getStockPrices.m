function StockPrices = getStockPrices(VZ,INTC,JPM,AAPL,MSFT,PG)
%Get stock prices from the data files  
    VZStockPrice = table2array(VZ(:,6));
    INTCStockPrice = table2array(INTC(:,6));
    JPMStockPrice = table2array(JPM(:,6));
    APPLStockPrice = table2array(AAPL(:,6));
    MSFTStockPrice = table2array(MSFT(:,6));
    PGStockPrice = table2array(PG(:,6));
%     for i=1:1537
%         VZStockPrice(i) = table2array(VZ(i,6));
%         INTCStockPrice(i) = table2array(INTC(i,6));
%         JPMStockPrice(i) = table2array(JPM(i,6));
%         APPLStockPrice(i) = table2array(AAPL(i,6));
%         MSFTStockPrice(i) = table2array(MSFT(i,6));
%         PGStockPrice(i) = table2array(PG(i,6));
%     end
    
    StockPrices = [VZStockPrice, ...
                   INTCStockPrice, ...
                   JPMStockPrice, ...
                   APPLStockPrice, ...
                   MSFTStockPrice, ...
                   PGStockPrice];
end
