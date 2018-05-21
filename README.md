## Risk-Analysis
##### Masters Project Work - MATLAB
##### 1) Implemented a procedure to estimate the VaR and the ES of the P&L at 95% confidence level up to an horizon of 12 months (so you have to provide 12 VaR and 12 ES estimates). Under the assumption that the P&L over different months are independent and identically distributed according to the above distribution.
##### 2) Used convolution to build the distribution at the desired horizon, without using Monte Carlo simulation. Confirmed the results with above part 1
```matlab
%Given the following PnL and associated probaility of each PnL
probs = [0.05 0.15 0.2 0.3 0.25 0.05];
PnL = [   -5   -3  -1   1    3    5];
%Simulations size
B = 1000;
%To gain yearly, need 12 months - then go into 1000 simulations - then in
%each simulation add up the 12 numbers
for n=1:12
    for i = 1:B
        interationB = 0;
        for j = 1:n
            interationB = interationB + datasample(PnL,1,'Weights',probs);
        end
        simB(i) = interationB;
    end
    %Sort and index into the 5th percentile-assuming B is round digit(1000)
    sortsimB = sort(simB);
    %Take percentile
    VaR(n) = sortsimB(0.05*B);
    VaRindex = find(sortsimB==VaR(n));
    ES(n) = mean(sortsimB(1:VaRindex(1)));
    figure(1)
    subplot(4,3,n)
    %changed colour in report to green
    hist(simB)
    title(['n = ' num2str(n)])
    xlabel('PnL')
end

%Convolution - want to put each timestep into one list within A cell
convolution{1}=probs;
nodes{1}=PnL;
figure(2)
plot(nodes{1},convolution{1})
title('n = 1')
xlabel('PnL')
ylabel('Probability')
legend('n=1')
hold on
for i = 2:12
    nodes{i} = [-5*i:2:5*i];
    convolution{i} = conv(convolution{i-1},convolution{1});
    plot(nodes{i},convolution{i})
end
 title('Convolution distributions at various monthly horizons')
 xlabel('P&L')
 ylabel('probability')
 legend('n=1','n=2','n=3','n=4','n=5','n=6','n=7','n=8','n=9','n=10','n=11','n=12')
 hold off

%Get the VaR and ES in each list in each cell 
for i=1:12    
    %VaR calculation
    VaRindex = find(cumsum(convolution{i})>=0.05);
    VaRC(i) = nodes{i}(VaRindex(1));
   
    %ES
    CumSum = cumsum(convolution{i}(1:VaRindex(1)));
    ESC(i) = sum(nodes{i}(1:VaRindex(1)).*(convolution{i}(1:VaRindex(1))/CumSum(length(CumSum))));
end
%table of results
T = array2table([VaR; ES; VaRC; ESC]);
T.Properties.VariableNames = {'n1', 'n2', 'n3', 'n4', 'n5', 'n6', 'n7', 'n8', 'n9', 'n10', 'n11', 'n12'};
T.Properties.RowNames = {'VaRMC' 'ESMC' 'VaRConv' 'ESConv'}
```

##### This next section computes the VaR, Expected Shortfall and different risk measure for a stock portfolio and then a stock + Option portfolio (Options add Non-linear element)
##### This section below does some analysis on the stock data, calculates some statisitcs, calculates the VaR and ES with both a Gaussian (parametic) and Bootstrapping (non-parametic)
##### The portfolio is made of of Verizon (long 20 shares), Intel (long 10 shares), JPMorgan (long 10 shares), Apple (long 10 shares), Microsoft (long 4 shares), The Procter & Gamble Company (short 5 shares). The data sample refers to daily quotations for the period Jan 1st, 2012 to 9th of February 2018 (included)
##### NOTE: Not all functions are shown below, please see attached m files if you wish
```matlab
%ANALYSIS OF STOCK PORFOLIO ONLY (6 stocks)
% Load the data
load AAPLData.mat;load MSFTData.mat;load PGData.mat;load VZData.mat;load INTCData.mat;load JPMData.mat
%NUMBER of SHARES - %VZ, INTC, JPM, APPL, MSFT, PG
StockNumbers = [20, 10, 10, 10, 4, -5];
%Stock prices in order from loaded data
StockPrices = getStockPrices(VZ,INTC,JPM,AAPL,MSFT,PG);
%Total stoc Value
StockValues = getStockValues(StockPrices, StockNumbers);
%Initial portfolio value
[PortfolioValues, PortfolioReturns] = computePortfolioValue(StockNumbers, StockPrices); 

%Statistical Analysis - Plots, Skewness, Kurtosis, Bera-Jacque
[SK, K, JB] = getPlots(PortfolioReturns);

%VarianceRatio
[VRMontly,zscoreM,VRYearly,zscoreY] = computeVRTest(PortfolioReturns);

%%%%%%%% Gaussian VaR Function
function GaussianVaR = GaussVaR(logreturns, alpha)
    z = norminv(1-alpha);
    mu = mean(logreturns);
    sd = std(logreturns);
    Gaussian = -(mu + z*sd);
    ExpectedShortfall = -(mu - (sd/(1-alpha))*normpdf(z));
    GaussianVaR = [Gaussian ExpectedShortfall];
end

%%%%%%%% Bootstrap VaR Function
function BootStrapVaR = BootVaR(logreturns, nine, m) 
    %Interpolation 
    n=length(logreturns);
    per = (1-nine)*n;
    perfl = floor(per);
    perflpone = perfl +1;
    gamma = per-perfl;

    VaRSum=0; ESSum=0;
    for i=1:m 
        for j=1:n
            randomnumber = randi([1, n]);
            bootstrap(j) = logreturns(randomnumber);
        end
        bootstrapsort = sort(bootstrap);
        VaRboottemp = (1-gamma)*bootstrapsort(perfl) + gamma*bootstrapsort(perflpone);
        VaRSum = VaRSum + VaRboottemp;
        ESSum = ESSum + (sum(bootstrapsort(1:perfl))/perfl);
    end
    BootStrapVaRavg = -VaRSum/m;  
    ESBootstrap = -ESSum/m;  
    BootStrapVaR = [BootStrapVaRavg, ESBootstrap];
end

%Define alpha the users wants for VaR calculation - taking 99% in this case
%Carry out VaR analysis - Kupiec test, conditional test, Independance of VaR violations
starty = 625;alpha= 0.99; 
[VaRBoot99, vioBoot99, vioNumBoot99] = VaRViolations(1, alpha, starty, PortfolioReturns, 3);
[VaRGauss99,vioGauss99, vioNumGauss99] = VaRViolations(2, alpha, starty, PortfolioReturns, 4);
[KupiecBoot99, statB99] = Kupiec(vioNumBoot99, alpha, VaRBoot99); %Kupiec Test of Var Model
[KupiecGauss99, statG99] = Kupiec(vioNumGauss99, alpha, VaRGauss99);
[LRIndB99, statIB99, LRccB99, outcomeCB99] = independence(VaRBoot99, vioBoot99, KupiecBoot99); %Independence Tests
[LRIndG99, statIG99, LRccG99, outcomeCG99] = independence(VaRGauss99, vioGauss99, KupiecGauss99);
```
##### The next sections combines the above 6 stocks with options, which ofcourse changes the way we can compute our risk due to non-linearity of Options within the portfolio.
##### The Options portfolio include 1) short apple 7 calls, strike at 140, expiry on April 20th 2018 2) MSFT: long 6 puts at strike of 95, expiry on July 20st 2018 and 3)PG: long 10 calls at strike 85, expiry on June 16, 2018
##### This time the 10 day VaR was calculated as of 9th February 2018 along with marginal and component VaR
```matlab
%Now compute the Var using the stocks and options as a Portfolio
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
```
##### The VaR is computed firsdtly by historical simulation and full revaluation and secondly historical simulation and delta-gamma approximation
##### Note again the functions used are attached as m files
```matlab
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
```
