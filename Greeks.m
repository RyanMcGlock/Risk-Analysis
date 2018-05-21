function OptionGreeks = Greeks(iopt, S, K, sigma, r, T, dyd)

    d1 = (log(S/K)+(r-dyd+sigma^2/2)*T)/(sigma*sqrt(T));
    d2 = (log(S/K)+(r-dyd-sigma^2/2)*T)/(sigma*sqrt(T));

    if iopt == 1
        Delta = exp(-dyd*T)*normcdf(d1);
        Gamma = (exp(-dyd*T)/(S*sigma*sqrt(T)))*exp((-(d1^2))/2)*(1/sqrt(2*pi));
        Theta = (-1*(((S*sigma*exp(-dyd*T))/(2*sqrt(T)))*exp((-(d1^2))/2)*(1/sqrt(2*pi))) -...
                r*K*exp(-r*T)*normcdf(d2) + ...
                dyd*S*exp(-dyd*T)*normcdf(d1))/360;
    end
    if iopt == -1
        Delta = exp(-dyd*T)*(normcdf(d1)-1);
        Gamma = (exp(-dyd*T)/(S*sigma*sqrt(T)))*exp((-(d1^2))/2)*(1/sqrt(2*pi));
        Theta = (-1*(((S*sigma*exp(-dyd*T))/(2*sqrt(T)))*exp((-(d1^2))/2)*(1/sqrt(2*pi))) +...
                r*K*exp(-r*T)*normcdf(-d2) - ...
                dyd*S*exp(-dyd*T)*normcdf(-d1))/360;
    end
    
    OptionGreeks = [Theta, Delta, Gamma];
    
end