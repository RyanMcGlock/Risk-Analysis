clear; clc;
%ANALYSIS OF STOCK PORFOLIO ONLY
% Load the data
load AAPLData.mat;load MSFTData.mat;load PGData.mat;load VZData.mat;
load INTCData.mat;load JPMData.mat
%SHARES - %VZ, INTC, JPM, APPL, MSFT, PG
StockNumbers = [20, 10, 10, 10, 4, -5];
%Stock prices in order from loaded data
StockPrices = getStockPrices(VZ,INTC,JPM,AAPL,MSFT,PG);
%Total stoc Value
StockValues = getStockValues(StockPrices, StockNumbers);
%Initial portfolio value
[PortfolioValues, PortfolioReturns] = computePortfolioValue(StockNumbers, StockPrices); 

%Plots, Skewness, Kurtosis, Bera-Jacque
[SK, K, JB] = getPlots(PortfolioReturns);

%VarianceRatio
[VRMontly,zscoreM,VRYearly,zscoreY] = computeVRTest(PortfolioReturns);


starty = 625;alpha= 0.9; 
%WANT TO DO VAR METHODS PLUS ANALYSIS - 90alpha
[VaRBoot90, violationsBoot90, violationsNumBoot90] = VaRViolations(1, alpha, starty, PortfolioReturns,1);
[VaRGauss90,violationsGauss90, violationsNumGauss90] = VaRViolations(2, alpha, starty, PortfolioReturns,2);
[KupiecB90, outcomeB90] = Kupiec(violationsNumBoot90, alpha, VaRBoot90); %Kupiec Test of Var Model
[KupiecG90, outcomeG90] = Kupiec(violationsNumGauss90, alpha, VaRGauss90);
[LRIndB90, outcomeIB90, LRccB90, outcomeCB90] = independence(VaRBoot90, violationsBoot90, KupiecB90); %Independence Tests
[LRIndG90, outcomeIG90, LRccG90, outcomeCG90] = independence(VaRGauss90, violationsGauss90, KupiecG90);

alpha = 0.99;
[VaRBoot99, vioBoot99, vioNumBoot99] = VaRViolations(1, alpha, starty, PortfolioReturns, 3);
[VaRGauss99,vioGauss99, vioNumGauss99] = VaRViolations(2, alpha, starty, PortfolioReturns, 4);
[KupiecBoot99, statB99] = Kupiec(vioNumBoot99, alpha, VaRBoot99); %Kupiec Test of Var Model
[KupiecGauss99, statG99] = Kupiec(vioNumGauss99, alpha, VaRGauss99);
[LRIndB99, statIB99, LRccB99, outcomeCB99] = independence(VaRBoot99, vioBoot99, KupiecBoot99); %Independence Tests
[LRIndG99, statIG99, LRccG99, outcomeCG99] = independence(VaRGauss99, vioGauss99, KupiecGauss99);

%Table
T = table(...
    ([PortfolioValues(end)*VaRBoot90(end,1)  PortfolioValues(end)*VaRBoot90(end,2)  violationsNumBoot90  KupiecB90 {outcomeB90} LRIndB90 {outcomeIB90} LRccB90 {outcomeCB90}]'), ...
    ([PortfolioValues(end)*VaRGauss90(end,1) PortfolioValues(end)*VaRGauss90(end,2) violationsNumGauss90 KupiecG90 {outcomeG90} LRIndG90 {outcomeIG90} LRccG90 {outcomeCG90}]'), ...
    ([PortfolioValues(end)*VaRBoot99(end,1)  PortfolioValues(end)*VaRBoot99(end,2)  vioNumBoot99  KupiecBoot99 {statB99} LRIndB99 {statIB99} LRccB99 {outcomeCB99}]'), ...
    ([PortfolioValues(end)*VaRGauss99(end,1) PortfolioValues(end)*VaRGauss99(end,2) vioNumGauss99 KupiecGauss99 {statG99} LRIndG99 {statIG99} LRccG99 {outcomeCG99}]'));
T.Properties.VariableNames = {'Boot90', 'Gauss90', 'Boot99', 'Gauss99'};
T.Properties.RowNames = {'VaR' 'ES' 'NumViolations' 'KupiecVal' 'KupiecOut' 'LRInd' 'LRIndOut' 'LRCC' 'LRCCCOut'}

DayNumber = [length(PortfolioValues)-length(VaRBoot90)+1:length(PortfolioValues)]';
FTPortfolioValues = PortfolioValues(length(PortfolioValues)-length(VaRBoot90)+1:end)';
FT = table(DayNumber, FTPortfolioValues.*VaRBoot90(:,1), FTPortfolioValues.*VaRBoot90(:,2), FTPortfolioValues.*VaRGauss90(:,1), FTPortfolioValues.*VaRGauss90(:,2),...
    FTPortfolioValues.*VaRBoot99(:,1), FTPortfolioValues.*VaRBoot99(:,2), FTPortfolioValues.*VaRGauss99(:,1), FTPortfolioValues.*VaRGauss99(:,2));
FT.Properties.VariableNames = {'DayNum' 'VaRBoot90', 'ESBoot90', 'VaRGauss90', ...
    'ESGauss90', 'VaRBoot99', 'ESBoot99', 'VaRGauss99', 'ESGauss99'}

%MRC Basel Capital
alpha=0.99;
MRCharge = (MRC(alpha, starty, PortfolioReturns))*PortfolioValues(end)
disp('MRCharge in dollars')


