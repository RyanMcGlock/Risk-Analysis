function BootStrapVaR = BootVaR(logreturns, nine, m) 
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
