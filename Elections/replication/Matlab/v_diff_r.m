function f = v_diff_r(x)
global beta p_d  xt_1 vvd vvr x_grid at_1 lambda ecost_r
vd = interp1(x_grid,vvd,x,'spline' );
vr = interp1(x_grid,vvr,x,'spline' );
v = -abs(xt_1-x) + lambda*at_1 + beta*(vd*p_d + vr*(1-p_d)) -ecost_r;

f = v-vd;