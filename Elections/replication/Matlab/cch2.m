function y=cch2(x,v1,v2,p)
% This m-file is based on Krasnokutskya (2009)
[w,v,dw]=chf1(x,v1,v2);
rr=dw./w;
if p==0
    y=real(rr);
else
    y=(rr-real(rr))/1i;
    
end