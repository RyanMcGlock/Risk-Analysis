function [SK, K, JB] = getPlots(PortfolioReturns)
    figure(1)
    %%%%%%%%%Histogram v Gaussian
    subplot(2,2,1)
    %histogram(PortfolioReturns)
    histfit(PortfolioReturns)
    %fit normal on the curve for your data
%     pd=fitdist(PortfolioReturns(:),'normal');
%     x = -0.06:0.0001:0.06;
%     PDF = pdf(pd,x);
%     PDF = PDF/max(PDF);
%     y = [0 ,210];
%     PDF = PDF*y(2);
%     hold on
%     plot(x,PDF,'r-','LineWidth',1.5)
%     hold off
    %title('Empirical PDF vs. Gaussian PDf')
    title('Empirical PdF vs. Gaussian PdF')
    xlabel('returns')
    %%%%%%%%%%%%%%%QQPlot
    subplot(2,2,2)
    qqplot(PortfolioReturns) %graph = Heavy tailed normal distribution. Leptokurtic.
    %title('QQPlot')
    %Autocorrelation of returns
    subplot(2,2,3)
    autocorr(PortfolioReturns)
    title('AutoCorrlation of Returns')
    %Autocorrelation of squared returns
    PortfolioReturnsSquared = PortfolioReturns.^2;
    subplot(2,2,4)
    autocorr(PortfolioReturnsSquared)
    title('AutoCorrelation of Returns Squared')
    %Jarque?Bera
    SK = skewness(PortfolioReturns);
    K = kurtosis(PortfolioReturns);
    JB=((length(PortfolioReturns)/6)*(SK^2))+((length(PortfolioReturns)/24)*((K-3)^2)); 
    %Reject null hypothesis of normally distributed returns.
    
    
end