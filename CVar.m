function [ComponentVaR,ComponentES] = CVar(MVaR,MES, StockShares, OptionData)
%ComponentVaR = CVar(MVaR, StockShares, OptionData)

%     IndWeightsS = StockValues(1537,:)./InitialPortfolioValue;
%     IndWeightsO = (OptionData(:,2).*OptionData(:,1))./InitialPortfolioValue;
%     
%     IndWeights = [IndWeightsS IndWeightsO'];
    Positions = [StockShares OptionData(:,2)'];
    TotalPosition = sum(Positions);
    ComponentVaR = MVaR .* (Positions./TotalPosition);
    %Component Expected shortfall
    ComponentES = MES .* (Positions./TotalPosition);
end