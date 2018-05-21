function [PortfolioValue, PortfolioReturns] = computePortfolioValue(StockShares, StockPrices)
%Compute Portfolio Value
%day 1537 value
    PortfolioValue = sum((StockShares.*StockPrices(:,:))');
    for i=2:length(PortfolioValue)
        PortfolioReturns(i-1) = log(PortfolioValue(i)/PortfolioValue(i-1));
    end
    
    PortfolioFinalValue = sum(StockShares.*StockPrices(length(StockPrices),:));
end