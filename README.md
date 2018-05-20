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
