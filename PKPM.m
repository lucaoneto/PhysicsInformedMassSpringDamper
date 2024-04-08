clear
close all
clc
warning('off','all');

%%

scenario_selection
if strcmp(scen_2,'_nn')==1, seed_max=1;
else, seed_max=30; end

for seed=1:seed_max
    name=strcat('Data/DatGen_Seed',int2str(seed));
    load(name)
    
    %%
    if strcmp(strcat(scen_1,scen_2),'_l_nn')==1, D  = D_l_nn; u  = u_l; surroga='y';
    elseif strcmp(strcat(scen_1,scen_2),'_l_n')==1, D  = D_l_n; u  = u_l; surroga='y';
    elseif strcmp(strcat(scen_1,scen_2),'_nl_nn')==1, D  = D_nl_nn; u  = u_nl; surroga='n';
    elseif strcmp(strcat(scen_1,scen_2),'_nl_n')==1, D  = D_nl_n; u  = u_nl; surroga='n';
    end

    fprintf('Seed %d\n',seed)

    %% k0-mu tuning
    tic
    D_FKPM = D;
    if surroga=='y'
        k0 = 250;
        mu = 3;
    else
        y = D_FKPM(:,2);
        err_best = +Inf;
        i = 0;        
        for u0 = logspace(-1,3,15*5) 
            i = i + 1;
            for mu = logspace(-1,3,15*5) 
                for k0 = logspace(-1,3,15*5) 
                    yp = euler_solver(@(y) linear_mass_spring_damper(y, m, mu, k0), [u0,0], dt, num_steps);
                    up = yp(1,ix)';
                    err = mean(abs(y-up));
                    if (err_best > err)
                        err_best = err;
                        mu_best = mu;
                        k0_best = k0;
                    end
                end
            end
        end
        k0=k0_best;
        mu=mu_best;
    end
    
    %%

    p_max = 30;
    n = size(D,1);
    C = zeros(p_max+1,p_max+1);
    for j = 2:p_max
        for k = 2:p_max
            C(j+1,k+1) = j*k*(j-1)*(k-1)/(j+k-3);
        end
    end
    P1 = zeros(p_max+1,p_max+1); P2 = P1; P3 = P1; P4 = P1; P5 = P1;
    for i = 0:p_max
        for j = 0:p_max
                               P1(i+1,j+1) = 1/(i+j+1);
            if (i>=1 && j>=1), P2(i+1,j+1) = i*j/(i+j-1);       end
            if (i>=1),         P3(i+1,j+1) = i/(i+j);           end
            if (i>=2 && j>=1), P4(i+1,j+1) = i*(i-1)*j/(i+j-2); end
            if (i>=2),         P5(i+1,j+1) = i*(i-1)/(i+j-1);   end
        end
    end
    P = m^2*C+mu^2*P2+k0^2*P1+k0*mu*(P3+P3')+mu*m*(P4+P4')+k0*m*(P5+P5');
    X = zeros(n,p_max+1);
    for j = 0:p_max
        X(:,j+1) = D(:,1).^j;
    end
    y = D(:,2);
    err_best = +Inf;
    i = 0;
    for p = 0:p_max
        i = i + 1;
        fprintf('%02d/%02d\n',i,31)
        PP = P(1:p+1,1:p+1);
        CC = C(1:p+1,1:p+1);
        for lambda1 = logspace(-6,6,13*5)
            for lambda2 = logspace(-6,6,13*5)
                yp = zeros(n,1);
                for it = 1:n
                    il = [1:it-1,it+1:n];
                    XX = X(il,1:p+1);
                    w = (XX'*XX+lambda1*CC+lambda2*PP)\XX'*y(il);
                    yp(it) = X(it,1:p+1)*w;
                end
                err = mean(abs(y-yp));
                if (err_best > err)
                    err_best = err;
                    p_best = p;
                    XX = X(:,1:p+1);
                    lambda1_best=lambda1;
                    lambda2_best=lambda2;
                    w_best = (XX'*XX+lambda1*CC+lambda2*PP)\XX'*y;
                end
            end
        end
    end
    time_train (seed) = toc;
    p = p_best;
    X = zeros(length(t),p+1);
    for j = 0:p
        X(:,j+1) = t.^j;
    end
    tic
    u_p = X*w_best;
    time_test(seed) = toc / length(t);
    err_int(seed)=mean(abs(u_p(1:itm)-u(1:itm)));
    err_est(seed)=mean(abs(u_p(itm+1:end)-u(itm+1:end)));
end

%% Plot
figure, hold on
plot(t, [u,u_p]);
plot(D(:,1), D(:,2),'ob');
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
    save Results/PKRes_l_nn_surr err_int err_est time_train time_test D t u u_p
elseif D==D_nl_nn
    save Results/PKRes_nl_nn err_int err_est time_train time_test D t u u_p
elseif D==D_l_n
    save Results/PKRes_l_n_surr err_int err_est time_train time_test D t u u_p
elseif D==D_nl_n
    save Results/PKRes_nl_n err_int err_est time_train time_test D t u u_p
end