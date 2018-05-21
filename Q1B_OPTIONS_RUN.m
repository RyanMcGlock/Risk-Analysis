clear; clc;
% Load the data that was downloaded from Yahoo!Finance
load VZData.mat;load INTCData.mat;load JPMData.mat;load AAPLData.mat
load MSFTData.mat;load PGData.mat
%VZ, INTC, JPM, APPL, MSFT, PG
StockPositions = [20, 10, 10, 10, 4, -5];
%[Option Market Price, Number, Strike, Days to Maturity, Sigma, Rate, Dividend]
%Order is important here
 OptionData = [20.075, -7, 140,  70, 0.3954, 0, 0.0169; 
               12.225,  6,  95, 161, 0.4103, 0, 0.0250;
                1.695, 10,  85, 126, 0.2046, 0, 0.0207];

%Stock prices
StockPrices = getStockPrices(VZ,INTC,JPM,AAPL,MSFT,PG);
%Stock priees by share
StockTotalValues = getStockValues(StockPrices, StockPositions);
%Initial portfolio value
InitialPortfolioValue = computePortfolioValueOption(StockPositions, StockPrices, OptionData); 
%Log returns
StockLogReturns = computeStockLogReturns(StockPrices);

% New price P=price(1537)*exp(logreturns)
CalculatedPrices = computeCalculatedPrices(StockPrices, StockLogReturns);

%LIBOR Rates Interpolation - Lint function does this nicely
fwdDays = 10;
OptionData(1,6) = LInt(OptionData(1,4)-fwdDays);
OptionData(2,6)= LInt(OptionData(2,4)-fwdDays);
OptionData(3,6)= LInt(OptionData(3,4)-fwdDays); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Historical Full Revaluation Approximation
% Calculate new option price using BS and the new prices computed above
for i=1:length(StockLogReturns)
    BlackSholesPrices(i,1) = OptionPriceBS(1, CalculatedPrices(i,4),OptionData(1,:),fwdDays);
    BlackSholesPrices(i,2) = OptionPriceBS(-1,CalculatedPrices(i,5),OptionData(2,:),fwdDays);
    BlackSholesPrices(i,3) = OptionPriceBS(1, CalculatedPrices(i,6),OptionData(3,:),fwdDays);
end

% Calculate Portofolio log returns by using the portfolio values at each
BootstrapPortfolioReturns = computeBootstrapPortfolioReturns(StockPositions, ...
                            CalculatedPrices, OptionData, BlackSholesPrices, ...
                                     InitialPortfolioValue);

subplot(1,2,1)
histfit(BootstrapPortfolioReturns)
title('Full-Reval P&L Distribution')
xlabel('P&L')
alpha=0.99;

VaRFullReval = BootVaR(BootstrapPortfolioReturns,alpha,10000);
VaRFullRevalValue = BootVaR(BootstrapPortfolioReturns,alpha,10000).*InitialPortfolioValue
 
%Marginal VaR
%VZ, INTC, JPM, APPLS, MSFTS, PGS, APPLO, MSFTO, PGO
for epsilon = 0.0001:0.0001:0.05
    [MVaRs,MES] = MVaR(BootstrapPortfolioReturns, StockTotalValues, StockPositions, CalculatedPrices, ...
                    OptionData, BlackSholesPrices, VaRFullReval(1), epsilon);

    [CVaR,CES] = CVar(MVaRs(2:10),MES(2:10), StockPositions, OptionData);
    VSums = sum(CVaR);
    CSums = sum(CES);
    %Bit funky - but need optimal epsilon
    if abs(VaRFullReval(1)-VSums)<=0.001
        epsilon
        VSums;
        abs(VaRFullReval(1)-VSums);
        break;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Historical Delta Gamma Approximation
DeltaGammaNewOptionPrice = computeDeltaGammaOptionPrice(StockPrices, ...
                           CalculatedPrices, OptionData);

% Calculate Portofolio log returns by using the portfolio values at each
DeltaGammaPortfolioReturns = computeBootstrapPortfolioReturns(StockPositions, ...
                             CalculatedPrices, OptionData, DeltaGammaNewOptionPrice, ...
                             InitialPortfolioValue);
subplot(1,2,2)
histfit(DeltaGammaPortfolioReturns)
title('Delta-Gamma P&L Distribution')
xlabel('P&L')

alpha=0.99;
VaRDeltaGamma = BootVaR(DeltaGammaPortfolioReturns,alpha,1536).*InitialPortfolioValue

%Report in percentage
MVaRs = MVaRs*100; MES=MES*100; CVaR=CVaR*100; CES=CES*100;

%Table - horrible code for a table but will do
S = table([MVaRs(2)  MES(2)  34.40 CVaR(1) CES(1)]',...
          [MVaRs(3)  MES(3)  17.24 CVaR(2) CES(2)]',...
          [MVaRs(4)  MES(4)  17.24 CVaR(3) CES(3)]',...
          [MVaRs(5)  MES(5)  17.24 CVaR(4) CES(4)]',...
          [MVaRs(6)  MES(6)  6.80  CVaR(5) CES(5)]',...
          [MVaRs(7)  MES(7) -8.60  CVaR(6) CES(6)]',...
          [MVaRs(8)  MES(8) -12.10 CVaR(7) CES(7)]',...
          [MVaRs(9)  MES(9)  10.30 CVaR(8) CES(8)]',...
          [MVaRs(10) MES(10) 17.24 CVaR(9) CES(9)]');
S.Properties.VariableNames = {'VZ', 'INTC', 'JPM', 'AAPL','MSFT','PG','AAPLO','MSFTO','PGO'};
S.Properties.RowNames = {'MVaR' 'MES' 'Weights' 'CVaR' 'CES'}

