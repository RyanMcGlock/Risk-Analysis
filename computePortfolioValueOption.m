function PortfolioValue = computePortfolioValueOption(StockShares, StockPrices, OptionData)
%Compute Portfolio Value
%day 1537 value
    StockPortfolio = sum(StockShares.*StockPrices(length(StockPrices),:));
    OptionPortfolio = sum(OptionData(:,1).*OptionData(:,2));

    PortfolioValue = StockPortfolio + OptionPortfolio;
end