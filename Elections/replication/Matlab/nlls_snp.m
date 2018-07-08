function f = nlls_snp(x)
global u_d l_d u_r l_r xr_grid xd_grid n_grid
global party3 p_1 p_2 vote cut_d_grid cut_r_grid
global pud pld pur plr n1 p_grid prob
global n_app 
global pdf_d pdf_r
global sigr sigd
global mu_d mu_r
global pd_pos pr_pos

sig = x;

svote = zeros(n1,1);
v_grid = zeros(n_grid,1);

for i=1:n1
if party3(i)==1 

    for k=1:n_app
        if (u_d(k) > l_d(k))
            for j=1:n_grid
               v_grid(k,j)=max(normcdf(cut_d_grid(k,j),0,sig),1-normcdf(cut_d_grid(k,j),0,sig))*p_grid(i,k,j);
            end

            svote(i) = svote(i) + (0.5*pud(k)*normpdf(p_1(i)-u_d(k),0,sigd(1))*normpdf(p_2(i)-mu_d(2)*u_d(k),0,sigd(2))...
                                +  0.5*pld(k)*normpdf(p_1(i)-l_d(k),0,sigd(1))*normpdf(p_2(i)-mu_d(2)*l_d(k),0,sigd(2))...
                                +  trapz(xd_grid(k,:),v_grid(k,:)))*pdf_d(k)/prob(i,k)/pd_pos;
        end
            
    end

else
    for k=1:n_app
        if (u_r(k) > l_r(k))
            for j=1:n_grid
                v_grid(k,j)=max(normcdf(cut_r_grid(k,j),0,sig),1-normcdf(cut_r_grid(k,j),0,sig))*p_grid(i,k,j);
            end 

            svote(i) = svote(i) + (0.5*pur(k)*normpdf(p_1(i)-u_r(k),0,sigr(1))*normpdf(p_2(i)-mu_r(2)*u_r(k),0,sigr(2))...
                                +  0.5*plr(k)*normpdf(p_1(i)-l_r(k),0,sigr(1))*normpdf(p_2(i)-mu_r(2)*l_r(k),0,sigr(2))...
                                +  trapz(xr_grid(k,:),v_grid(k,:)))*pdf_r(k)/prob(i,k)/pr_pos;
        end
    end


end
end


% disp(mean(svote(party3==1)))
% disp(mean(vote(party3==1)))
% disp(mean(svote(party3==2)))
% disp(mean(vote(party3==2)))

%disp([vote svote])
f = sum((vote-svote).^2);
f= f*100;
