# PhysicsInformedMassSpringDamper 

In this repository, you can find the code of the toy example proposed in the paper "A Review on Full-, Zero-, and Partial-Knowledge based Predictive Models for Industrial Applications" (Section 4 - Illustrative Example).

Experiments were conducted using MATLAB R2023a - Update 6 (9.14.0.2489007) on a Windows 10 machine with Intel(R) Core(TM) i7-8550U and 16 GB of RAM.

## Underlying physics
The toy example analyzes a mass-spring-damper system with no external force applied. We consider the case of the mass initially positioned at a specific point $u_0$, that is left free to evolve autonomously over time.

<p align="center">
<img width='250' src='https://github.com/lucaoneto/PhisicsInformedMassSpringDamper/assets/158032647/119b7700-74e8-4225-94cb-168d1f228c49'>
</p>

In the simplest case, a mass-spring-damper system can be described by a second-order differential equation (see Section 4)
$$m \frac{d^2 u(t)}{d t^2} + \mu \frac{d u(t)}{d t} + k_0 u(t) = 0 \ \text{,} \quad \text{(Eq13)}$$
where $m$ is the mass (measured in $[kg]$), $\mu$ is the damping coefficient (measured in $[\frac{Ns}{m}]$), and $k_0$ is the spring constant.

For scenarios where the linear approximation of the proportional relationship between force and displacement of the spring is insufficient, a more complex representation should be considered (see Section 4)
$$m \frac{d^2 u(t)}{d t^2} + \mu \frac{d u(t)}{d t} + k_1 u(t) + k_2 u^3(t) = 0 \ \text{,} \quad \text{(Eq14)}$$
where $k_1$ and $k_2$ are the spring linear and nonlinear coefficients (measured in $[\frac{N}{m}]$ and $[\frac{N}{m^3}]$ respectively)

## Introduction

**Given a mass-spring-damper system, our scope is to predict the mass’s position $(u(t))$ at any given time in the range $[0, t_f]$** 

We will compare three types of predictive model to infer the mass position: 
- Full-Knowledge Predicitve Model (FKPM);
- Zero-Knowledge Predicitve Model (ZKPM);
- Partial-Knowledge Predicitve Model (PKPM).

In the model building phase, we assume:
- to know $\text{(Eq13)}$
- to know the value of the parameter $m$, but not the values of $k_0$ and $\mu$;
- to know the value of the initial condition $v_0$ (initial velocity equal to $0$), but not the value of $u_0$;
- to have the capability to measure the displacement $u(t)$ of the mass at various moments in time $t$ in the range $[0,t_m]$ ($t_m \< t_f$).

The measurements of the displacement $u_i(t)$ are stored in the dataset $\mathcal{D}_n = \{ (t_1,u(t_1)), \cdots, (t_n,u(t_n)) \}$. 
For the scope of this example, the datasets are synthetically generated: $\mathcal{D}_n$ is sampled from the ground truth solution (i.e., solution obtained knowing the value of all the parameters).

The performance of the predictive models are analyzed in different conditions of (see Section 4):
- data-generating model (ground truth solution of $\text{(Eq13)}$ and $\text{(Eq14)}$);
- quality of the measures (presence of noise).

Four scenarios are studied:
1. Surrogation scenario with no noise: Dataset $\mathcal{D}^{13, 0}_n$ generated by $\text{(Eq13)}$;
2. Surrogation scenario with noise: Dataset $\mathcal{D}^{13, \sigma}_n$ generated by $\text{(Eq13)}$ and currupted by Gaussian noise;
3. Modeling scenario with no noise: Dataset $\mathcal{D}^{14, 0}_n$ generated by $\text{(Eq14)}$;
4. Modeling scenario with noise: Dataset $\mathcal{D}^{14, \sigma}_n$ generated by $\text{(Eq14)}$ and currupted by Gaussian noise.

We measured the performance of each predictive model in the four scenarios.
In presence of noise, experiemens are repeated 30 times to avoid randomness and obtain robust results.

Here process outline:
1. Data generation;
2. The four scenarios approached with FKPM;
3. The four scenarios approached with ZKPM;
4. The four scenarios approached with PKPM;
5. Analysis of the results.

## Repository
The repository cointains five main scripts:
- [DATGEN.m](DATGEN.m) (Data generation);
- [FKPM.m](FKPM.m) (FKPM);
- [ZKPM.m](ZKPM.m) (ZKPM);
- [PKPM.m](PKPM.m) (PKPM);
- [RISTAB.m](RISTAB.m) (Table of results);
- [RISPLOT.m](RISPLOT.m) (Plot of results);

and four utility scripts:
- [scenario_selection.m](scenario_selection.m) (UI for the scenario selection);
- [linear_mass_spring_damper.m](linear_mass_spring_damper.m) (Implementing $\text{(Eq13)}$);
- [nonlinear_mass_spring_damper.m](nonlinear_mass_spring_damper.m) (Implementing $\text{(Eq14)}$);
- [euler_solver.m](euler_solver.m) (Differential equation Euler-method solver);

## Code
### [DATGEN.m](DATGEN.m)
`DATGEN.m` solves the ground truth solutions $\text{(Eq13)}$ and $\text{(Eq14)}$, samples the datasets $\mathcal{D}^{13, 0}_n$, $\mathcal{D}^{13, \sigma}_n$, $\mathcal{D}^{14, 0}_n$, and $\mathcal{D}^{14, \sigma}_n$, plots the solutions and saves the datasets in the folder Data.

The differential equations $\text{(Eq13)}$ and $\text{(Eq14)}$ are solved with the Euler method.
For both solutions the script samples 22 points equally spaced in the range $[0,t_m]$, creating the datasets $\mathcal{D}^{13, 0}_n$ and $\mathcal{D}^{14, 0}_n$.
Datasets $\mathcal{D}^{13, \sigma}_n$ and $\mathcal{D}^{14, \sigma}_n$ are obtained from $\mathcal{D}^{13, 0}_n$ and $\mathcal{D}^{14, 0}_n$ respectively, by adding random noise (intensity factor $\sigma=0.1$) to the samples.
The script perform 30 repetitions with different values of random noise and for each repetition saves the data in `DatGen_Seed_X.mat` (where `X` is the repetition number).
Each file contains the datasets $\mathcal{D}^{13, 0}_n$ (`D_l_nn`), $\mathcal{D}^{13, \sigma}_n$ (`D_l_n`), $\mathcal{D}^{14, 0}_n$ (`D_nl_nn`), and $\mathcal{D}^{14, \sigma}_n$ (`D_nl_n`), the value of $m$ (`m`), the vector containing the time instants in which the solution is evaluated (`t`), the solution $u(t)$ of $\text{(Eq13)}$ and $\text{(Eq14)}$ (`u_l` and `u_nl`), the integration step (`dt`), the number of integration steps (`num_steps`), the step number of $t_m$ (`itm`), and the step number of the sampled data (`ix`).
For the last repetition, `DATGEN.m` plots the ground truth solution of $\text{(Eq13)}$ and $\text{(Eq14)}$, the comparison plot, and some of the sampled points.

### [FKPM.m](FKPM.m)
`FKPM.m` is the full-knowledge approach.

When the user runs `FKPM.m`, the interface requires the selection of the scenario (Surrogation scenario with no noise, Surrogation scenario with noise, Modeling scenario with no noise, Modeling scenario with noise).
According to the selected scenario, the script loads a different dataset ($\mathcal{D}^{13, 0}_n$, $\mathcal{D}^{13, \sigma}_n$, $\mathcal{D}^{14, 0}_n$, and $\mathcal{D}^{14, \sigma}_n$).
Note that the FKPM is performed with reduced datasets (one every two samples), since FKPMs are usually chosen in presence of few historical samples:
```matlab
D_FKPM = D(1:2:end,:);
```
We assume that the parameters $k_0$, $\mu$, and $u_0$ are unknown.
The script grid-searches the parameters in the range $[10^{-1}, 10^{3}]$.
For each combination of $k_0$, $\mu$, and $u_0$, the script solves the $\text{(Eq13)}$ with the Euler method and computes the error committed in predicting the values of $u_i(t)$ of the datasets.
The combination of $k_0$, $\mu$, and $u_0$ that produces the lowest error is chosen as the best.
`FKPM.m` solves the $\text{(Eq13)}$ with the best combination of parameters and computes the error committed in interpolation (interval $[0,t_m]$) and extapolation (interval $[t_m,t_f]$) with respect to the ground truth solution.
For scenarios in which the dataset is corrupted by noise, the procedure is repeated 30 times.
When the dataset has no noise only 1 repetition is performed.
The results are saved in the file `FKRes_Y.mat` (where `Y` indicates the scenario: `_l_nn` for Surrogation scenario with no noise, `_l_n` for Surrogation scenario with noise, `_nl_nn` for Modeling scenario with no noise, and `_nl_n` for Modeling scenario with noise) in the folder Results.
The saved file contains the errors of interpolation and extapolation for each repetition (`err_int` and `err_est`), the mean time of training and testing (`time_train` and `time_test`), the dataset (`D`), the vector containing the time instants in which the solution is evaluated  (`t`), the ground truth solution (`u`) and the one predicted by FKPM (`u_p`).
The script plots the comparison between the ground truth solution and the one predicted by FKPM in the last repetition, with the dataset points.

Note: generate the datasets using DATGEN.m before running FKPM.m.

### [ZKPM.m](ZKPM.m)
`ZKPM.m` is the zero-knowledge approach.

When the user runs `ZKPM.m`, the interface requires the selection of the scenario (Surrogation scenario with no noise, Surrogation scenario with noise, Modeling scenario with no noise, Modeling scenario with noise).
According to the selected scenario, the script loads a different dataset ($\mathcal{D}^{13, 0}_n$, $\mathcal{D}^{13, \sigma}_n$, $\mathcal{D}^{14, 0}_n$, and $\mathcal{D}^{14, \sigma}_n$).

`ZKPM.m` contains a regularized polynomial regression algorithm, with functional form:
$$f(x) = \sum_{i= 0}^p w_i x^i \ \text{.}$$
The model parameters are $w_i$.
We define the loss function as (For further details, see Section 4 - Illustrative Example):
$$l(w)= \quad \|| X \boldsymbol{w} - \boldsymbol{y} \||^2 + \lambda \boldsymbol{w}' C \boldsymbol{w} \ \text{.}$$
The weights that minimize the loss function can be obtained in closed form:
$$\boldsymbol{w} = (X' X + \lambda C)^+ X' \boldsymbol{y} \ \text{.}$$
The model hyperparameters are the polynomial grade $p$ and the regularization coefficient $\lambda$.
For the hyperparameters tuning, the script performs cross-validation applying the leave-one-out technique.
The procedure of optimization of the weights is performed using a dataset obtained leaving one data out from the original dataset.
Then, the error of the obtained polynomial is evaluated on the single data left out.
This procedure is repeated for each data in the dataset, evaluating the mean of computed the error.
The combination of the hyperpatameters that produces the lowest mean error is chosen as the best.
Finally, the weights $\boldsymbol{w}$ are optimized using the whole dataset using the best hyperpatameters.
`ZKPM.m` infers the predicted solution and computes the error committed in interpolation (interval $[0,t_m]$) and extapolation (interval $[t_m,t_f]$) with respect to the ground truth solution.
For scenarios in which the dataset is corrupted by noise, the whole process is repeated 30 times.
When the dataset has no noise only 1 repetition is performed.
The results are saved in the file `ZKRes_Y.mat` (where `Y` indicates the scenario: `_l_nn` for Surrogation scenario with no noise, `_l_n` for Surrogation scenario with noise, `_nl_nn` for Modeling scenario with no noise, and `_nl_n` for Modeling scenario with noise) in the folder Results.
The saved file contains the errors of interpolation and extapolation for each repetition (`err_int` and `err_est`), the mean time of training and testing (`time_train` and `time_test`), the dataset (`D`), the vector containing the time instants in which the solution is evaluated (`t`), the ground truth solution (`u`) and the one predcited by ZKPM (`u_p`).
The script plots the comparison between the ground truth solution and the one predicted by ZKPM in the last repetition, with the dataset points.

Note: generate the datasets using DATGEN.m before running ZKPM.m.

### [PKPM.m](PKPM.m)
`PKPM.m` is the partial-knowledge approach.

When the user runs `PKPM.m`, the interface requires the selection of the scenario (Surrogation scenario with no noise, Surrogation scenario with noise, Modeling scenario with no noise, Modeling scenario with noise).
According to the selected scenario, the script loads a different dataset ($\mathcal{D}^{13, 0}_n$, $\mathcal{D}^{13, \sigma}_n$, $\mathcal{D}^{14, 0}_n$, and $\mathcal{D}^{14, \sigma}_n$).

PKPM combines FKPM and ZKPM.
`PKPM.m` contains a regularized polynomial regression algorithm, with functional form:
$$f(x) = \sum_{i= 0}^p w_i x^i \ \text{.}$$
The loss function of PKPM differs from the one of ZKPM, since it contains a physical regularization term (For further details, see Section 4 - Illustrative Example):
$$l(w)= \quad \|| X \boldsymbol{w} - \boldsymbol{y} \||^2 + \lambda_1 \boldsymbol{w}' C \boldsymbol{w} + \lambda_2 \boldsymbol{w}' P \boldsymbol{w} \ \text{.}$$
Again, the weights that minimize the loss function can be obtained in closed form:
$$\boldsymbol{w} = (X' X + \lambda_1 C + \lambda_2 P)^+ X' \boldsymbol{y} \ \text{.}$$
The physical regularization term requires to know the value of the parameters $k_0$, $\mu$, and $u_0$.
In scenarios of Surrogation, we assume to know the exact values of $k_0$, $\mu$, and $u_0$.
In scenarios of Modeling, the values of $k_0$, $\mu$, and $u_0$ are tuned as done in FKPM using the complete dataset.
The model hyperparameters are the polynomial grade $p$, the regularization coefficient $\lambda_1$, and the physical regularization coefficient $\lambda_2$.
For the hyperparameters tuning, the script performs cross-validation applying the leave-one-out technique.
Once the best hyperparameters are identified, the weights $\boldsymbol{w}$ are optimized using the whole dataset using the best hyperpatameters.
`PKPM.m` infers the predicted solution and computes the error committed in interpolation (interval $[0,t_m]$) and extapolation (interval $[t_m,t_f]$) with respect to the ground truth solution.
For scenarios in which the dataset is corrupted by noise, the whole process is repeated 30 times.
When the dataset has no noise only 1 repetition is performed.
The results are saved in the file `PKRes_Y.mat` (where `Y` indicates the scenario: `_l_nn_surr` for Surrogation scenario with no noise, `_l_n_surr` for Surrogation scenario with noise, `_nl_nn` for Modeling scenario with no noise, and `_nl_n` for Modeling scenario with noise) in the folder Results.
The saved file contains the errors of interpolation and extapolation for each repetition (`err_int` and `err_est`), the mean time of training and testing (`time_train` and `time_test`), the dataset (`D`), the vector containing the time instants in which the solution is evaluated (`t`), the ground truth solution (`u`) and the one predicted by PKPM (`u_p`).
The script plots the comparison between the ground truth solution and the best one predicted by PKPM in the last repetition, with the dataset points.

Note: generate the datasets using DATGEN.m before running PKPM.m.

### [RISPLOT.m](RIPLOT.m)
`RESPLOT.m` is used to plot and compare the predicted solutions.

When the user runs `RESPLOT.m`, the interface requires the selection of the scenario (Surrogation scenario with no noise, Surrogation scenario with noise, Modeling scenario with no noise, Modeling scenario with noise).
According to the selected scenario, the script loads the corresponding results of FKPM, ZKPM, and PKPM.

The script plots the ground truth, the dataset and the three predicted solution in the same graph and saves the image.

Note: run FKPM.m, ZKPM.m, PKPM,m for all the scenarios before running RISPLOT.m.

### [RISTAB.m](RISTAB.m)
`RESTAB.m` is used to create a table of the results.

The script loads the results of FKPM, ZKPM, and PKPM of the four the scenarios and creates a table containing all the outcomes.
We reported the statistics of the results, since some scenarios are repeated 30 times.
The script save the file `ResTab.xlsx`, containing:
- Median of the errors of interpolation and extrapolation;
- Mean of the errors of interpolation and extrapolation;
- Variance of the errors of interpolation and extrapolation;
- Standard deviation (assuming a Gaussian distribution) of the errors of interpolation and extrapolation;
- Mean of the time of training;
- Mean of the time of testing.

Note: run FKPM.m, ZKPM.m, PKPM,m for all the scenarios before running RISTAB.m.
