function [Kupiec, outcome] = Kupiec(j, alpha, VaR)
    Kupiec = -2*(j*log((1-alpha)/(j/length(VaR)))+(length(VaR)-j)...
             *log(alpha/(1-(j/length(VaR)))));
    chisq = icdf('chi2',0.95,1);
    if chisq>Kupiec
        outcome='Calibrated';
    else outcome='NotCalibrated';
end