function Price = optionPriceBS(iopt, S, OptionData,DaysForward)
    
    
    %dyd= dividened yield, T = maturity
    %Option pricing for BS - including dyd value

    d1 = (log(S/OptionData(3))+(OptionData(6)-OptionData(7)+(OptionData(5)^2)/2)*(OptionData(4)/250))/(OptionData(5)*sqrt((OptionData(4)-DaysForward)/250));
    d2 = (log(S/OptionData(3))+(OptionData(6)-OptionData(7)-(OptionData(5)^2)/2)*(OptionData(4)/250))/(OptionData(5)*sqrt((OptionData(4)-DaysForward)/250));

    %If iopt=1 means call option, iopt=-1 means put option
    if iopt == 1 
        Price =S*exp(-OptionData(7)*((OptionData(4)-DaysForward)/250))*normcdf(d1)-OptionData(3)*exp(-OptionData(6)*((OptionData(4)-DaysForward)/250))*normcdf(d2);
    else if iopt == -1 
        Price =-S*exp(-OptionData(7)*((OptionData(4)-DaysForward)/250))*normcdf(-d1)+OptionData(3)*exp(-OptionData(6)*((OptionData(4)-DaysForward)/250))*normcdf(-d2);
    end
end

    