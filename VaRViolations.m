function [VaR, violations, violationsnum] = VaRViolations(method, alpha, starty, logreturns,k)

if method == 1
    string = 'Boot';
    for i=0:(length(logreturns)-starty-1)
        % Method 1: Bootstrap
        %start-250 as assume each year is 250 days
        VaR(i+1,:) = BootVaR(logreturns((starty-250)+i:starty+i),alpha,length(logreturns((starty-250)+i:starty+i)));
        if logreturns(starty+i)<-VaR(i+1,1) 
            violations(i+1) = 1;
        else violations(i+1) = 0;
        end
    end
    violationsnum = sum(violations);
elseif method == 2
    string = 'Gauss';
    for i=0:(length(logreturns)-starty-1)
        VaR(i+1,:) = GaussVaR(logreturns((starty-250)+i:starty+i),alpha);
        % Check number of outliers (Part 3)
        if logreturns(starty+i)<-VaR(i+1,1) 
            violations(i+1) = 1;
        else violations(i+1) = 0;
        end
    end
    violationsnum = sum(violations);
end
    if k==1 || k==2
        mult = -0.03;
    elseif k==3 || k==4
        mult = -0.06;
    end
    
    figure(2)
    subplot(2,2,k)
    plot(mult*violations)
    hold on
    plot(-VaR(:,1), 'k','LineWidth', 2)
    hold on
    plot(-VaR(:,2), 'r','LineWidth', 2)
    hold off
    title([string ' ' num2str(alpha*100) '%, ' 'Violations = ' num2str(violationsnum)])
    xlabel('Days')

end

