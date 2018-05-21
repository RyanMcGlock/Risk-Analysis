function [MarginalVaR,MarginalES] = MVaR(BootstrapPortfolioReturns, StockValues, ...
    StockShares, CalculatedPrices, OptionData, BlackSholesPrices, VaR, epsilon)
%MarginalVaR = MVaR(BootstrapPortfolioReturns, StockValues, ...
    %StockShares, CalculatedPrices, OptionData, BlackSholesPrices, VaR, epsilon)

    MarginalReturns(:,1) = log((StockShares(1)*CalculatedPrices(:,1))/StockValues(length(StockValues),1));
    MarginalReturns(:,2) = log((StockShares(2)*CalculatedPrices(:,2))/StockValues(length(StockValues),2));
    MarginalReturns(:,3) = log((StockShares(3)*CalculatedPrices(:,3))/StockValues(length(StockValues),3));
    MarginalReturns(:,4) = log((StockShares(4)*CalculatedPrices(:,4))/StockValues(length(StockValues),4));
    MarginalReturns(:,5) = log((StockShares(5)*CalculatedPrices(:,5))/StockValues(length(StockValues),5));
    MarginalReturns(:,6) = log((StockShares(6)*CalculatedPrices(:,6))/StockValues(length(StockValues),6));
    MarginalReturns(:,7) = log(BlackSholesPrices(:,1)/OptionData(1,1));
    MarginalReturns(:,8) = log(BlackSholesPrices(:,2)/OptionData(2,1));
    MarginalReturns(:,9) = log(BlackSholesPrices(:,3)/OptionData(3,1));
    
    marginalreturnssorted = sortrows([BootstrapPortfolioReturns MarginalReturns],1);

    varDown = -abs(VaR) - epsilon;
    varUp = -abs(VaR) + epsilon;

    low=find(marginalreturnssorted(:,1)>=(varDown));
    low=low(1);

    up=find(marginalreturnssorted(:,1)<=(varUp));
    up=up(length(up));

    for i=1:10
        MarginalVaR(i) = mean(marginalreturnssorted(low:up,i));
    end
    
    %Want to find Marginal Expected Shortfall
    %So using our ES input - the expected shortfall - find the indexs below
    ESIndex = find(marginalreturnssorted(:,1)<=(-(abs(VaR))));
    ESIndex = ESIndex(length(ESIndex));
    for i=1:10
        MarginalES(i) = mean(marginalreturnssorted(1:ESIndex,i));
    end    
end