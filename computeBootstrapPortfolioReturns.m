function BootStrapPortfolioReturns = computeBootstrapPortfolioReturns(StockShares, ...
                                     CalculatedPrices, OptionData, BlackSholesPrices, ...
                                     InitialPortfolioValue)
    
    NewStockValues = StockShares.*CalculatedPrices;
    NewOptionValues = BlackSholesPrices.*OptionData(:,2)';
    
    AllNewValues = [NewStockValues NewOptionValues];
    BootStrapPortfolioReturns = log(sum(AllNewValues')'/InitialPortfolioValue);
end