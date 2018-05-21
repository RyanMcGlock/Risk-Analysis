function DeltaGammaNewOptionPrice = computeDeltaGammaOptionPrice(StockPrices, CalculatedPrices, OptionData)
    
    %Compute Greeks. Theta, Delta, Gamma
    greeksAPPL = Greeks(1,StockPrices(length(StockPrices),4),OptionData(1,3), ...
                 OptionData(1,5),OptionData(1,6),OptionData(1,4)/360,OptionData(1,7));
    greeksMSFT = Greeks(-1,StockPrices(length(StockPrices),5),OptionData(2,3), ...
                 OptionData(2,5),OptionData(2,6),OptionData(2,4)/360,OptionData(2,7));
    greeksPG = Greeks(1,StockPrices(length(StockPrices),6),OptionData(3,3), ...
                 OptionData(3,5),OptionData(3,6),OptionData(3,4)/360,OptionData(3,7));
    
    dt=10/250;
    %Compute dS = new price - price on 9th feb
    % theta*dt+delta*ds+0.5*gamma*ds^2
    for i=1:length(CalculatedPrices)
        dPrice(i,1) = CalculatedPrices(i,4) - StockPrices(length(StockPrices),4);
        dPrice(i,2) = CalculatedPrices(i,5) - StockPrices(length(StockPrices),5);
        dPrice(i,3) = CalculatedPrices(i,6) - StockPrices(length(StockPrices),6);
        CNew(i,1) = (greeksAPPL(1)*dt+greeksAPPL(2)*dPrice(i,1)+0.5*greeksAPPL(3)*(dPrice(i,1)^2))+OptionData(1,1);
        CNew(i,2) = (greeksMSFT(1)*dt+greeksMSFT(2)*dPrice(i,2)+0.5*greeksMSFT(3)*(dPrice(i,2)^2))+OptionData(2,1);
        CNew(i,3) = (greeksPG(1)*dt+greeksPG(2)*dPrice(i,3)+0.5*greeksPG(3)*(dPrice(i,3)^2))+OptionData(3,1);
    end
    
    DeltaGammaNewOptionPrice = CNew;

end