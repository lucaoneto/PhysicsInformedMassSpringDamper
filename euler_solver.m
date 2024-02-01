function y = euler_solver(ode_func, y0, dt, num_steps)
    y = zeros(length(y0), num_steps);
    y(:,1) = y0;
    for i = 1:num_steps-1
        y(:,i+1) = y(:,i) + dt * ode_func(y(:,i));
    end
end