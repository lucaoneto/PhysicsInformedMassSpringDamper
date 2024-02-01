clear all
close all
clc

format long

load Results/FKRes_l_nn.mat
tab_medn(1:2,1)=[median(err_int);median(err_est)];
tab_mean(1:2,1)=[mean(err_int);mean(err_est)];
tab_var(1:2,1)=[0;0];
tab_sdg(1:2,1)=[0;0];
load Results/FKRes_l_n.mat
tab_medn(1:2,2)=[median(err_int);median(err_est)];
tab_mean(1:2,2)=[mean(err_int);mean(err_est)];
tab_var(1:2,2)=[var(err_int);var(err_est)];
i=sort(err_int); e=sort(err_est);
tab_sdg(1:2,2)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];
% load Results/FKRes_l_nn_21dati.mat
% tab_medn(1:2,3)=[median(err_int);median(err_est)];
% tab_mean(1:2,3)=[mean(err_int);mean(err_est)];
% tab_var(1:2,3)=[0;0];
% tab_sdg(1:2,3)=[0;0];
% load Results/FKRes_l_n_21dati.mat
% tab_medn(1:2,4)=[median(err_int);median(err_est)];
% tab_mean(1:2,4)=[mean(err_int);mean(err_est)];
% tab_var(1:2,4)=[var(err_int);var(err_est)];
% i=sort(err_int); e=sort(err_est);
% tab_sdg(1:2,4)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];
load Results/ZKRes_l_nn.mat
tab_medn(1:2,3)=[median(err_int);median(err_est)];
tab_mean(1:2,3)=[mean(err_int);mean(err_est)];
tab_var(1:2,3)=[0;0];
tab_sdg(1:2,3)=[0;0];
load Results/ZKRes_l_n.mat
tab_medn(1:2,4)=[median(err_int);median(err_est)];
tab_mean(1:2,4)=[mean(err_int);mean(err_est)];
tab_var(1:2,4)=[var(err_int);var(err_est)];
i=sort(err_int); e=sort(err_est);
tab_sdg(1:2,4)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];
% load Results/PKRes_l_nn.mat
% tab_medn(1:2,7)=[median(err_int);median(err_est)];
% tab_mean(1:2,7)=[mean(err_int);mean(err_est)];
% tab_var(1:2,7)=[0;0];
% tab_sdg(1:2,7)=[0;0];
% load Results/PKRes_l_n.mat
% tab_medn(1:2,8)=[median(err_int);median(err_est)];
% tab_mean(1:2,8)=[mean(err_int);mean(err_est)];
% tab_var(1:2,8)=[var(err_int);var(err_est)];
% i=sort(err_int); e=sort(err_est);
% tab_sdg(1:2,8)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];
load Results/PKRes_l_nn_surr.mat
tab_medn(1:2,5)=[median(err_int);median(err_est)];
tab_mean(1:2,5)=[mean(err_int);mean(err_est)];
tab_var(1:2,5)=[0;0];
tab_sdg(1:2,5)=[0;0];
load Results/PKRes_l_n_surr.mat
tab_medn(1:2,6)=[median(err_int);median(err_est)];
tab_mean(1:2,6)=[mean(err_int);mean(err_est)];
tab_var(1:2,6)=[var(err_int);var(err_est)];
i=sort(err_int); e=sort(err_est);
tab_sdg(1:2,6)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];

load Results/FKRes_nl_nn.mat
tab_medn(3:4,1)=[median(err_int);median(err_est)];
tab_mean(3:4,1)=[mean(err_int);mean(err_est)];
tab_var(3:4,1)=[0;0];
tab_sdg(3:4,1)=[0;0];
load Results/FKRes_nl_n.mat
tab_medn(3:4,2)=[median(err_int);median(err_est)];
tab_mean(3:4,2)=[mean(err_int);mean(err_est)];
tab_var(3:4,2)=[var(err_int);var(err_est)];
i=sort(err_int); e=sort(err_est);
tab_sdg(3:4,2)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];
% load Results/FKRes_nl_nn_21dati.mat
% tab_medn(3:4,3)=[median(err_int);median(err_est)];
% tab_mean(3:4,3)=[mean(err_int);mean(err_est)];
% tab_var(3:4,3)=[0;0];
% i=sort(err_int); e=sort(err_est);
% tab_sdg(3:4,3)=[0;0];
% load Results/FKRes_nl_n_21dati.mat
% tab_medn(3:4,4)=[median(err_int);median(err_est)];
% tab_mean(3:4,4)=[mean(err_int);mean(err_est)];
% tab_var(3:4,4)=[var(err_int);var(err_est)];
% i=sort(err_int); e=sort(err_est);
% tab_sdg(3:4,4)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];
load Results/ZKRes_nl_nn.mat
tab_medn(3:4,3)=[median(err_int);median(err_est)];
tab_mean(3:4,3)=[mean(err_int);mean(err_est)];
tab_var(3:4,3)=[0;0];
tab_sdg(3:4,3)=[0;0];
load Results/ZKRes_nl_n.mat
tab_medn(3:4,4)=[median(err_int);median(err_est)];
tab_mean(3:4,4)=[mean(err_int);mean(err_est)];
tab_var(3:4,4)=[var(err_int);var(err_est)];
i=sort(err_int); e=sort(err_est);
tab_sdg(3:4,4)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];
load Results/PKRes_nl_nn.mat
tab_medn(3:4,5)=[median(err_int);median(err_est)];
tab_mean(3:4,5)=[mean(err_int);mean(err_est)];
tab_var(3:4,5)=[0;0];
tab_sdg(3:4,5)=[0;0];
load Results/PKRes_nl_n.mat
tab_medn(3:4,6)=[median(err_int);median(err_est)];
tab_mean(3:4,6)=[mean(err_int);mean(err_est)];
tab_var(3:4,6)=[var(err_int);var(err_est)];
i=sort(err_int); e=sort(err_est);
tab_sdg(3:4,6)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];
% load Results/PKRes_nl_nn_surr.mat
% tab_medn(3:4,9)=[median(err_int);median(err_est)];
% tab_mean(3:4,9)=[mean(err_int);mean(err_est)];
% tab_var(3:4,9)=[0;0];
% tab_sdg(3:4,9)=[0;0];
% load Results/PKRes_nl_n_surr.mat
% tab_medn(3:4,10)=[median(err_int);median(err_est)];
% tab_mean(3:4,10)=[mean(err_int);mean(err_est)];
% tab_var(3:4,10)=[var(err_int);var(err_est)];
% i=sort(err_int); e=sort(err_est);
% tab_sdg(3:4,10)=[0.5*(i(end-10)-i(11));0.5*(e(end-10)-e(11))];

Tab = array2table([tab_medn(1:2,:);tab_mean(1:2,:);tab_var(1:2,:);tab_sdg(1:2,:);tab_medn(3:4,:);tab_mean(3:4,:);tab_var(3:4,:);tab_sdg(3:4,:)], ...
    'VariableNames',{'FKPM - No Noise','FKPM - Noise','ZKPM - No Noise','ZKPM - Noise','PKPM - No Noise','PKPM - Noise'}, ...
    'RowNames',{'Median - Interpolation Error (Surrogation)','Median - Extrapolation Error (Surrogation)','Mean - Interpolation Error (Surrogation)','Mean - Extrapolation Error (Surrogation)', ...
    'Variance - Interpolation Error (Surrogation)','Variance - Extrapolation Error (Surrogation)','StndDev (Gaussian) - Interpolation Error (Surrogation)','StndDev (Gaussian) - Extrapolation Error (Surrogation)'...
    'Median - Interpolation Error (Modeling)','Median - Extrapolation Error (Modeling)','Mean - Interpolation Error (Modeling)','Mean - Extrapolation Error (Modeling)', ...
    'Variance - Interpolation Error (Modeling)','Variance - Extrapolation Error (Modeling)','StndDev (Gaussian) - Interpolation Error (Modeling)','StndDev (Gaussian) - Extrapolation Error (Modeling)'});

writetable(Tab,'ResTab.xlsx','Sheet',1,'WriteRowNames',true)
