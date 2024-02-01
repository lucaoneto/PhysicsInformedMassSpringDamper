function dydt = nonlinear_mass_spring_damper(y, m, mu, k0, k2)
    dydt = [y(2); (-mu*y(2) - k0*y(1) - k2*y(1)^3) / m];
end