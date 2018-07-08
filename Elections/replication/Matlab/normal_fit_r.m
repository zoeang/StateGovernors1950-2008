function f = normal_fit_r(x)
global ter ker mode

mu   =  0;
sig  = x;
f1  = normpdf(ter(:,mode),mu,sig);
f2  = ker(:,mode);    

f = sum((f1-f2).^2);