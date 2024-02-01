function dydt = linear_mass_spring_damper(y, m, mu, k0)
    dydt = [y(2); (-mu*y(2) - k0*y(1)) / m];
end