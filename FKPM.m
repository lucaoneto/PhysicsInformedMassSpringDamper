clear
close all
clc

%%

scenario_selection
if strcmp(scen_2,'_nn')==1, seed_max=1;
else, seed_max=30; end

for seed=1:seed_max
    name=strcat('Data/DatGen_Seed',int2str(seed));
    load(name)
    
    %%
    if strcmp(strcat(scen_1,scen_2),'_l_nn')==1, D  = D_l_nn; u  = u_l;
    elseif strcmp(strcat(scen_1,scen_2),'_l_n')==1, D  = D_l_n; u  = u_l;
    elseif strcmp(strcat(scen_1,scen_2),'_nl_nn')==1, D  = D_nl_nn; u  = u_nl;
    elseif strcmp(strcat(scen_1,scen_2),'_nl_n')==1, D  = D_nl_n; u  = u_nl;
    end
    
    fprintf('Seed %d\n',seed)

    %% FKPM
    D_FKPM = D(1:2:end,:);
    ix = ix(1:2:end);
    y = D_FKPM(:,2);
    err_best = +Inf;
    i = 0;
    tic
    for u0 = logspace(-1,3,15*5) 
        i = i + 1;
        fprintf('%02d/%02d\n',i,15*5)
        for mu = logspace(-1,3,15*5) 
            for k0 = logspace(-1,3,15*5) 
                yp = euler_solver(@(y) linear_mass_spring_damper(y, m, mu, k0), [u0,0], dt, num_steps);
                up = yp(1,ix)';
                err = mean(abs(y-up));
                if (err_best > err)
                    err_best = err;
                    mu_best=mu;
                    u0_best=u0;
                    k0_best=k0;
                    up_best = yp(1,:)';
                end
            end
        end
    end
    time_train(seed) = toc;
    u_p = up_best;
    err_int(seed)=mean(abs(u_p(1:itm)-u(1:itm)));
    err_est(seed)=mean(abs(u_p(itm+1:end)-u(itm+1:end)));

    tic % Testing time
    yp = euler_solver(@(y) linear_mass_spring_damper(y, m, mu_best, k0_best), [u0_best,0], dt, num_steps);
    time_test(seed) = toc / length(t);
end

%% Plots
figure, hold on
plot(t, [u,u_p]);
plot(D_FKPM(:,1), D_FKPM(:,2),'ob');
legend('True','Predicted','Data')
ylabel('Displacement');
ylim([-1.1,1.1]);

%% Results
fprintf('Error Interpolation (Median) = %f\n', median(err_int))
fprintf('Error Extrapolation (Median) = %f\n', median(err_est))
fprintf('Training Time (Median) = %e\n',median(time_train))
fprintf('Test Time (Median) =     %e\n',median(time_test))

%% Save
mkdir("Results")
if D==D_l_nn
    save Results/FKRes_l_nn err_int err_est time_train time_test D t u u_p
elseif D==D_nl_nn
    save Results/FKRes_nl_nn err_int err_est time_train time_test D t u u_p
elseif D==D_l_n
    save Results/FKRes_l_n err_int err_est time_train time_test D t u u_p
elseif D==D_nl_n
    save Results/FKRes_nl_n err_int err_est time_train time_test D t u u_p
end