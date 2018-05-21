function CalculatedPrices = computeCalculatedPrices(StockPrices, StockLogReturns)
% generate 10 random numbers and pick the returns with index that random
% number. add all 10 returns to get 10-day return
% repeat this 1537 times
    for i=1:length(StockLogReturns)
            for j=1:10
                randomnum = randi([1,length(StockLogReturns)]);
                VZboot(i,j) = StockLogReturns(randomnum,1);
                INTCboot(i,j) = StockLogReturns(randomnum,2);
                JPMboot(i,j) = StockLogReturns(randomnum,3);
                APPLboot(i,j) = StockLogReturns(randomnum,4);
                MSFTboot(i,j) = StockLogReturns(randomnum,5);
                PGboot(i,j) = StockLogReturns(randomnum,6);
            end
        VZcalculatedPrice(i) = StockPrices(length(StockPrices),1)*exp(sum(VZboot(i,:)));
        INTCcalculatedPrice(i) = StockPrices(length(StockPrices),2)*exp(sum(INTCboot(i,:)));
        JPMcalculatedPrice(i) = StockPrices(length(StockPrices),3)*exp(sum(JPMboot(i,:)));
        APPLcalculatedPrice(i) = StockPrices(length(StockPrices),4)*exp(sum(APPLboot(i,:)));
        MSFTcalculatedPrice(i) = StockPrices(length(StockPrices),5)*exp(sum(MSFTboot(i,:)));
        PGcalculatedPrice(i) = StockPrices(length(StockPrices),6)*exp(sum(PGboot(i,:)));
    end


    CalculatedPrices = [VZcalculatedPrice', ...
                       INTCcalculatedPrice', ...
                       JPMcalculatedPrice', ...
                       APPLcalculatedPrice', ...
                       MSFTcalculatedPrice',...
                       PGcalculatedPrice'];
end