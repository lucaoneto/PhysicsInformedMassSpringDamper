clear
close all
clc

%% Common Parameters
m = 1;                  %[kg] mass
mu = 3;                 %[kg/s] damping coefficient
tf = 1;                 %[s] timespan
dt = 0.001;             %[s] integration step
u0 = 1;                 %[m] initial position
v0 = 0;                 %[m] initial velocity

%% Linear
k0 = 250;               %[N/m] stiffness - constant coefficient

%% Non Linear 
k1 = 230;               %[N/m] stiffness - constant coefficient
k2 = 3;                 %[N/m^3] stiffness - quadratic coefficient

%% Solutions
num_steps = tf / dt;
t = linspace(0, tf, num_steps)';
y0 = [u0; v0];
%
y = euler_solver(@(y) linear_mass_spring_damper(y, m, mu, k0), y0, dt, num_steps);
u_l = y(1,:)';
% v_l = y(2,:)';
% a_l = [diff(v_l)./diff(t); 0];
%
y = euler_solver(@(y) nonlinear_mass_spring_damper(y, m, mu, k1, k2), y0, dt, num_steps);
u_nl = y(1,:)';
% v_nl = y(2,:)';
% a_nl = [diff(v_nl)./diff(t); 0];

%% Data
mkdir("Data")
for seed =1:30
    n     = 22;
    sigma = .1;
    i = round(num_steps/3); itm = i; i = round(linspace(1,i,n)); i = i(1:n); ix = i;
    noise = sigma*randn(n,1);
    D_l_nn  = [t(i), u_l(i)];
    D_nl_nn = [t(i), u_nl(i)];
    D_l_n   = [t(i), u_l(i)+noise];
    D_nl_n  = [t(i), u_nl(i)+noise];

    %% Save
    name=strcat('Data/DatGen_Seed',int2str(seed));
    save(name, "D_l_nn", "D_nl_nn", "D_l_n", "D_nl_n", "m", "t", "u_l", "u_nl", "dt", "num_steps", "itm", "ix")
end

%% Plot
D_l_nn  = D_l_nn(1:2:end,:);
D_nl_nn = D_nl_nn(1:2:end,:);
D_l_n   = D_l_n(1:2:end,:); 
D_nl_n  = D_nl_n(1:2:end,:);  
h = figure('Position',[0,0,1400,700]+10);
subplot(3,1,1); hold on, grid on, box on
plot(t, u_l,'LineWidth',2,'Color',"#0072BD"); 
plot(D_l_nn(:,1), D_l_nn(:,2), 'o', 'MarkerSize',13,'LineWidth',3,'Color',"#D95319"); 
plot(D_l_n(:,1), D_l_n(:,2),   'd', 'MarkerSize',13,'LineWidth',3,'Color',"#EDB120"); 
ylim([-1.1,1.1])
xlim([0,1])
title('FKPM of Eq. (13)','Interpreter','latex')
legend('FKPM of Eq. (13)','$\mathcal{D}^{(13),0}_n$','$\mathcal{D}^{(13),\sigma}_n$', ...
       'Interpreter','latex','Location','northeastoutside')
set(gca,'FontSize',25,'TickLabelInterpreter','latex')
plot([1/3,1/3],[-2.2,2.2],':k','LineWidth',3,'HandleVisibility','off')
subplot(3,1,2); hold on
plot(t, u_nl,'LineWidth',2,'Color',"#77AC30"); 
plot(D_nl_nn(:,1), D_nl_nn(:,2), 'o', 'MarkerSize',13,'LineWidth',3,'Color',"#4DBEEE"); 
plot(D_nl_n(:,1), D_nl_n(:,2),   'd', 'MarkerSize',13,'LineWidth',3,'Color',"#7E2F8E"); 
ylim([-1.1,1.1])
xlim([0,1])
ylabel('$u(t)$','Interpreter','latex');
title('FKPM of Eq. (14)','Interpreter','latex')
legend('FKPM of Eq. (14)','$\mathcal{D}^{(14),0}_n$','$\mathcal{D}^{(14),\sigma}_n$', ...
       'Interpreter','latex','Location','northeastoutside')
set(gca,'FontSize',25,'TickLabelInterpreter','latex')
plot([1/3,1/3],[-2.2,2.2],':k','LineWidth',3,'HandleVisibility','off')
subplot(3,1,3); hold on
plot(t, u_l,'LineWidth',1.5,'Color',"#0072BD"); 
plot(t, u_nl,':','LineWidth',2.5,'Color',"#77AC30"); 
ylim([-1.1,1.1])
xlim([0,1])
xlabel('$t$','Interpreter','latex');
title('Comparison: FKPM of Eq. (13) vs FKPM of Eq. (14)','Interpreter','latex')
legend('FKPM of Eq. (13)','FKPM of Eq. (14)', ...
       'Interpreter','latex','Location','northeastoutside')
set(gca,'FontSize',25,'TickLabelInterpreter','latex')
plot([1/3,1/3],[-2.2,2.2],':k','LineWidth',3,'HandleVisibility','off')
text(1/3+.01,-.9,'$t_m$','Interpreter','latex','FontSize',25)
saveas(h,'toy1.eps','epsc')