%% note
% solving for election standards and valufuction of median voter 
% in no term limit case
global n_app 
% global u_d2 l_d2 u_r2 l_r2 
% global a_grid

%% define matrix

x0(1) = -3.5;
x0(2) = -3.5;

%% solving for system of equations
options = optimoptions('fsolve','TolFun',1.0e-10,'Display','off');
[x,fval] = fsolve(@myfun_ntl2,x0,options);

%% update election standards
n=n_app;

%% plot
% figure    
% plot(a_grid,u_d2,'Color','b','LineStyle','-','LineWidth',2)
% hold on
% plot(a_grid,u_r2,'Color','r','LineStyle','--','LineWidth',2)
% hold on
% plot(a_grid,l_d2,'Color','b','LineStyle','-.','LineWidth',2)
% hold on
% plot(a_grid,l_r2,'Color','r','LineStyle',':','LineWidth',2)
% hold on
% hleg = legend('D upper','R upper','D lower','R lower' );
% set(hleg, 'Box','off','Location','NorthWest')
% title('Election Stadard ntl')
% xlabel('competence')
% ylabel('ideology')
% axis([-1 1 -1.2 1.2])



