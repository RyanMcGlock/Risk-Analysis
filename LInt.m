function LIBORInterpolation = LInt(maturity)
%Linear Interpolation for rates
days = [30,60,90,180];
rates = [0.0158077,0.0168324,0.0181050,0.0202633];

%Function from here - passing in x
Up=(find(days>maturity));Up=Up(1);
Low=find(days<maturity);Low=Low(length(Low));
T1=days(Low);T2=days(Up);
LT1=rates(Low);LT2=rates(Up);

LIBORInterpolation = (((T2-maturity)*LT1)+((maturity-T1)*LT2))/(T2-T1);
end