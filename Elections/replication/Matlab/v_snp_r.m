function f = v_snp_r(x)
global beta p_d  xt_1 vvd vvr x_grid at_1 lambda ecost_r 

vd = interp1(x_grid,vvd,x);
vr = interp1(x_grid,vvr,x);

f = -abs(xt_1-x) + lambda*at_1 -ecost_r+beta*(vd*p_d + vr*(1-p_d));

