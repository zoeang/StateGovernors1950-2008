function f = normal_fit_d(x)
global ted ked mode

mu   =  0;
sig  = x;
f1  = normpdf(ted(:,mode),mu,sig);
f2  = ked(:,mode);

    

f = sum((f1-f2).^2);