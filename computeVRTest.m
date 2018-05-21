function [VRm,z_nm,VRy,z_ny] = computeVRTest(logreturns)
    %Variance Ratio Test
    % vratiotest(logreturns) %since it returns 1, we reject the null of zero 
                             %autocorrelation. There is serial correlation present                     
    %Yearly Variance Ration - Need to decide which one
    starty = 31;
    endVRy = 281;
    j=1;
    for i = 0:251:(length(logreturns)-endVRy)
        yearlyReturns(j) = sum(logreturns(starty+i:endVRy+i));
        j = j+1;
    end
    %Monthly Variance Ratio test
    startm = 18;
    endVRm = 48;
    j=1;
    %%We want 30 days of non-overlapping intervals(31 days to next start)
    for i = 0:31:(length(logreturns)-endVRm)
        monthlyReturns(j) = sum(logreturns(startm+i:endVRm+i));
        j = j+1;
    end
    %Variance Ratio Formula
    dailyvar = var(logreturns);
    cumvary = var(yearlyReturns);
    cumvarm = var(monthlyReturns);
    T = 6; nm=30;ny = 250;
    VRm = cumvarm/(nm*dailyvar);
    z_nm = (VRm-1)/sqrt((2*(nm-1))/(nm*T));
    VRy = cumvary/(ny*dailyvar);
    z_ny = (VRy-1)/sqrt((2*(ny-1))/(ny*T));
    %Accept the null H_0:no serial correlation in the returns. Assumption
    %needed for Gauss VaR.
end