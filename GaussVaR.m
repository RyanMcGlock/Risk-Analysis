function GaussianVaR = GaussVaR(logreturns, alpha)
    z = norminv(1-alpha);
    mu = mean(logreturns);
    sd = std(logreturns);
    Gaussian = -(mu + z*sd);
    ExpectedShortfall = -(mu - (sd/(1-alpha))*normpdf(z));
    GaussianVaR = [Gaussian ExpectedShortfall];
end