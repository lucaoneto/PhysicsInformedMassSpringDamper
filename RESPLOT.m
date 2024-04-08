clear
close all
clc

%%

scenario_selection
if strcmp(strcat(scen_1,scen_2),'_l_nn')==1, linearity  = 'l'; noise='nn'; surrogate='_surr'; img_num=2;
elseif strcmp(strcat(scen_1,scen_2),'_l_n')==1, linearity  = 'l'; noise='n'; surrogate='_surr'; img_num=3;
elseif strcmp(strcat(scen_1,scen_2),'_nl_nn')==1, linearity  = 'nl'; noise='nn'; surrogate=''; img_num=4;
elseif strcmp(strcat(scen_1,scen_2),'_nl_n')==1, linearity  = 'nl'; noise='n'; surrogate=''; img_num=5;
end

FK=strcat('Results/FKRes_',linearity,'_',noise);
ZK=strcat('Results/ZKRes_',linearity,'_',noise);
PK=strcat('Results/PKRes_',linearity,'_',noise,surrogate);
img_name=strcat('toy',int2str(img_num),'.eps');

load (FK); u_pF = u_p;
load (ZK); u_pZ = u_p;
load (PK); u_pP = u_p;

%%
if noise == "nn"
    h = figure('Position',[0,0,1400,470]+10); hold on, grid on, box on
    plot(t, u,                 '-',  'LineWidth',2,               'Color',"#0072BD")
    plot(t, u_pF,                '-.', 'LineWidth',3,               'Color',"#D95319")
    plot(t, u_pZ,                ':',  'LineWidth',3,               'Color',"#7E2F8E")
    plot(t, u_pP,                '--', 'LineWidth',3,               'Color',"#EDB120")
    plot(D(1:2:end,1), D(1:2:end,2),'*','MarkerSize',12,'LineWidth',3, 'Color',"#77AC30");
    plot(D(:,1),       D(:,2),      'o','MarkerSize',15,'LineWidth',3, 'Color',"#4DBEEE");
    ylim([-2.2,2.2])
    xlim([0,1])
    legend('Grount Truth','FKPM','ZKPM','PKPM', ...
           '$\mathcal{D}_{11}^{(13),0}$','$\mathcal{D}_{22}^{(13),0}$', ...
           'Interpreter','latex','Location','northeastoutside')
    ylabel('$u(t)$','Interpreter','latex');
    xlabel('$t$','Interpreter','latex');
    set(gca,'FontSize',25,'TickLabelInterpreter','latex')
    plot([1/3,1/3],[-2.2,2.2],':k','LineWidth',3,'HandleVisibility','off')
    text(1/3+.01,-2,'$t_m$','Interpreter','latex','FontSize',25)

elseif noise == "n"
    h = figure('Position',[0,0,1400,470]+10); hold on, grid on, box on
    plot(t, u,                 '-',  'LineWidth',2,               'Color',"#0072BD")
    plot(t, u_pF,                '-.', 'LineWidth',3,               'Color',"#D95319")
    plot(t, u_pZ,                ':',  'LineWidth',3,               'Color',"#7E2F8E")
    plot(t, u_pP,                '--', 'LineWidth',3,               'Color',"#EDB120")
    plot(D(1:2:end,1), D(1:2:end,2),'*','MarkerSize',12,'LineWidth',3, 'Color',"#77AC30");
    plot(D(:,1),       D(:,2),      'o','MarkerSize',15,'LineWidth',3, 'Color',"#4DBEEE");
    ylim([-2.2,2.2])
    xlim([0,1])
    legend('Grount Truth','FKPM','ZKPM','PKPM', ...
           '$\mathcal{D}_{11}^{(14),0}$','$\mathcal{D}_{22}^{(14),0}$', ...
           'Interpreter','latex','Location','northeastoutside')
    ylabel('$u(t)$','Interpreter','latex');
    xlabel('$t$','Interpreter','latex');
    set(gca,'FontSize',25,'TickLabelInterpreter','latex')
    plot([1/3,1/3],[-2.2,2.2],':k','LineWidth',3,'HandleVisibility','off')
    text(1/3+.01,-2,'$t_m$','Interpreter','latex','FontSize',25)
end

saveas(h,img_name,'epsc')