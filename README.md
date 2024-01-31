# PhisicsInformedMassSpringDamper

In this repository, you can find the code of the toy example proposed in the paper "A Review on Full-, Zero-, and Partial-Knowledge based Predictive Models for Industrial Applications" (Section 4 - Illustrative Example).

- Fisica dell'esempio mass-spring-damper:
  - modello lineare
  - modello non lineare
- Intro: 
  - cosa vogliamo fare? abbiamo un mass-spring-damper, possiamo misurare alcuni dati e vogliamo predirre la posizione della massa nel tempo
  - L'obbiettivo è paragonare 3 tecniche: fkpm, zkpm, pkpm
  - In che modo? Analizziamo 4 scenari (lineare con e senza noise, non lineare con e senza noise). Generiamo un dataset sintetico per ogni scenario. Con ciascuna delle 3 tecniche affrontiamo i 4 scenari.
  - Per ciacuna analisi, dire che facciamo 30 ripetizioni per robustezza sul noise. Dove non c'è noise non ci sono ripetizioni
  - Come è organizzato il repository? 5 file principali: data generation, fkpm, zkpm, pkpm, risultati; 3 file ausiliari: eulero...; 2 file di risultato: RisTab e RisPlot.
- Data generation:
  - Cosa fa? Risolve le equazioni differenziali lineare e non lineare "ground truth" con eulero. Crea i dataset (per ogni scenario, 30 iterazioni). Nel file salva anche cose aggiuntive (time, u(t)...)
- FKPM:
  - Cosa fa? Risolve l'equazione differenziale con eulero, ma non ha i parametri. Prende il dataset e fa grid search sui parametri in base all'errore prodotto sul dataset.
  - FKPM usa 1/3 dei dati (fairy comparison).
  - salva i risultati in due file: FKPM_X_X salva errori, tempi medi, k_best e m_best nelle tabelle (per ciscuna ripetizione), FKRis_X_X salva il vettore della soluzione u(t) dell'ultima ripòetizione
  - Ciascun run risolve uno scenario. Dire come impostare lo scenario.
  - Per gli scenari con noise impostare le 30 ripetizioni
- ZKPM:
  - Cosa fa? Fitta un polinomio di grado p sui dati con regolarizzazione sull'integrale della derivata seconda. 2 iperparametri p e lambda, trovati con grid search.
  - Minimizzazione della loss in forma chiusa. 
  - salva i risultati in due file:  ZKPM_X_X salva errori e tempi medi nelle tabelle (per ciscuna ripetizione), ZKRis_X_X salva il vettore della soluzione u(t) dell'ultima ripòetizione
  - Ciascun run risolve uno scenario. Dire come impostare lo scenario.
  - Per gli scenari con noise impostare le 30 ripetizioni
- PKPM:
  - Cosa fa? Fitta un polinomio di grado p sui dati con regolarizzazione sull'integrale della derivata seconda e con vincolo fisico sull'equazione differenziale. I parametri dell'equazione differenziale sono corretti nello scenario surrogate, mentre nello scenario modeling sono tunati con FKPM. 3 iperparametri p e lambda1, e lambda2 trovati con grid search.
  - Minimizzazione della loss in forma chiusa. 
  - salva i risultati in due file: PKPM_X_X salva errori e tempi medi nelle tabelle (per ciscuna ripetizione), PKRis_X_X salva il vettore della soluzione u(t) dell'ultima ripòetizione
  - Ciascun run risolve uno scenario. Dire come impostare lo scenario.
  - Per gli scenari con noise impostare le 30 ripetizioni
- Risultati
  - RisPlot: Prende i file FKRis_X_X,ZKRis_X_X,PKRis_X_X e crea un plot unico. Ciascun run risolve uno scenario. Dire come impostare lo scenario.
  - RisTab: Prende i file FKPM_X_X,ZKPM_X_X,PKPM_X_X e crea le tabelle di: mediana (sulle ripetizioni) dell'errore in interpolazione, mediana (sulle ripetizioni) dell'errore in estrapolazione, varianza (sulle ripetizioni) dell'errore in interpolazione, varianza (sulle ripetizioni) dell'errore in estrapolazione, varianza (sulle ripetizioni) gaussiana dell'errore in interpolazione, varianza gaussiana (sulle ripetizioni) dell'errore in estrapolazione, tempo medio (sulle ripetizioni) di training, tempo medio (sulle ripetizioni) di testing. Ciascuna tabella contiene i dati per ogni scenario.
 


## Underlying physics
The toy example analyzes a mass-spring-damper system with no external force applied. 

![4](https://github.com/lucaoneto/PhisicsInformedMassSpringDamper/assets/158032647/119b7700-74e8-4225-94cb-168d1f228c49)

We consider the case of the mass initially positioned at a specific point $u_0$, that is left free to evolve autonomously over time.

In the simplest case, a mass-spring-damper system can be described by a second-order differential equation
$$m \frac{d^2 u(t)}{d t^2} + \mu \frac{d u(t)}{d t} + k_0 u(t) = 0 \quad \text{(Eq1)}$$
  where $m$ is the mass (measured in $[kg]$), $\mu$ is the damping coefficient (measured in $[\frac{Ns}{m}]$), and $k_0$ is the spring constant.

For scenarios where the linear approximation of the proportional relationship between force and displacement of the spring is insufficient, a more complex representation can be considered
$$m \frac{d^2 u(t)}{d t^2} + \mu \frac{d u(t)}{d t} + k_1 u(t) + k_2 u^3(t) = 0 \quad \text{(Eq2)}$$
where $k_1$ and $k_2$ are the spring linear and nonlinear coefficients (measured in $[\frac{N}{m}]$ and $[\frac{N}{m^3}]$ respectively)

## Introduction
We assume to 
Given a mass-spring-damper system, we assume to have the capability to measure the displacement $u(t)$ of the mass at various moments in time $t$ in the range $[0,t_m]$.

**Our scope is to predict the mass’s position $(u(t))$ at any given time in the range $[0, t_f]$ ($t_f \> t_m$)** 

We will compare three methods to achive this target: 
- FKPM
- ZKPM
- PKPM

The measures are stored in the dataset $\mathcal{D}_n = \{ (t_1,u(t_1)), \cdots, (t_n,u(t_n)) \}$. 
For the scope of this examples, data are synthetically generated. 

We analyzed different conditions of:
- data-generating model ($\text{(Eq1)}$ or $\text{(Eq1)}$) 
- quality of the measures (presence of noise)

Overall, four scenarios are studied:
- Surrogation scenario with no noise: Dataset $\mathcal{D}^{1, 0}_n$ generated by $\text{(Eq1)}$
- Surrogation scenario with noise: Dataset $\mathcal{D}^{1, \sigma}_n$ generated by $\text{(Eq1)}$ currupted by noise
- Modeling scenario with no noise: Dataset $\mathcal{D}^{2, 0}_n$ generated by $\text{(Eq2)}$
- Modeling scenario with noise: Dataset $\mathcal{D}^{2, \sigma}_n$ generated by $\text{(Eq2)}$ currupted by noise

In presence of noise, experiemens are repeated 30 times to obtain robust results.
Even if the noise is randomly generated, the experiment reproducibility is guaranteed by the control of the random seed.

Our procedure is the following:
- Data generation
- The four scenarios approached with FKPM
- The four scenarios approached with ZKPM
- The four scenarios approached with PKPM
- Analysis of results

<!---
## Data Generation
In Data Generation we stored the script DatGen.m that produces the datasets. 
The code solves the equations $\text{(Eq1)}$ and $\text{(Eq2)}$ and extract 22 samples for each scenario:
- Dataset $\mathcal{D}^{1, 0}_n$ from $\text{(Eq1)}$
- Dataset $\mathcal{D}^{1, \sigma}_n$ from $\text{(Eq1)}$ and adding random noise
- Dataset $\mathcal{D}^{2, 0}_n$ from $\text{(Eq2)}$
- Dataset $\mathcal{D}^{2, \sigma}_n$ from $\text{(Eq2)}$ and adding random noise

The whole process is repeated 30 times, to average the random effect of the noise.
Data are saved in 30 files, named DatGen_SeedX.mat.

## FKPM
In FKPM you can find the script FKPM.m, containing the full-knowledge approach.
This model is built to solve the $\text{(Eq1)}$. 
We assume to not know the parameters $k_0$, $\mu$, and $u_0$, that are grid searched in the range $[10^{-1}, 10^{3}]$. 
The algorithm search for the best combination of $k_0$, $\mu$, and $u_0$ that produces the lowest error on the dataset. 
Note that the dataset used for this approach is reduced by 1/3 with respect to the original (see Section 4 - Illustrative Example).
The script can be modified, according to the scenario of interest:
- Surrogation scenario with no noise: to use the Dataset $\mathcal{D}^{1, 0}_n$, lines 11 and 12 must be set as:
  ```sh
    D  = D_l_nn;
    p  = p_l;
   ```
  - Surrogation scenario with noise: to use the Dataset $\mathcal{D}^{1, \sigma}_n$, lines 11 and 12 must be set as:
  ```sh
    D  = D_l_n;
    p  = p_l;
   ```
  - Modeling scenario with no noise: to use the Dataset $\mathcal{D}^{2, 0}_n$, lines 11 and 12 must be set as:
  ```sh
    D  = D_nl_nn;
    p  = p_nl;
   ```
  - Modeling scenario with noise: to use the Dataset $\mathcal{D}^{2, \sigma}_n$, lines 11 and 12 must be set as:
  ```sh
    D  = D_nl_n;
    p  = p_nl;
   ```
To average the random noise effect, the script performs 30 repetitions (line 6):
```sh
for seed=1:30
```
In scenarios with no noise, all the repetitions are identical. Then, it is convenient to perform only 1 repetition by setting line 6 as:
```sh
for seed=1:1
```
According to the selected scenario, the script will save 2 files:
- FKPM_X_X containing the evalutation of MAE is interpolation $[0,t_m]$ and extrapolation $(t_m, t_f]$, and the best values of $k_0$, $\mu$ for each repetition of the selected scenario 
- FKris_X_X containing the predicted $u(t)$ of the last repetition
  
## ZKPM
In ZKPM you can find the script ZKPM.m, containing the zero-knowledge approach.
We implemented a data-driven technique of structural risk minimization.
The functional form is a polynomial:
$$f(x) = \sum_{i= 0}^p w_i x^i$$
The loss function is defined as (see Section 4 - Illustrative Example):
$$l(w)= \quad \|| X \boldsymbol{w} - \boldsymbol{y} \||^2 + \lambda \boldsymbol{w}' C \boldsymbol{w}$$
The loss can be minimized in closed form:
$$\boldsymbol{w} = (X' X + \lambda C)^+ X' \boldsymbol{y}$$
The model has two hyperparameters: the polynomial grad $p$ and the regularization coefficient $\lambda$.
They are optimized on the validation set, built adopting the leave-one-out method.
The script can be modified, according to the scenario of interest:
- Surrogation scenario with no noise: to use the Dataset $\mathcal{D}^{1, 0}_n$, lines 11 and 12 must be set as:
  ```sh
    D  = D_l_nn;
    p  = p_l;
   ```
  - Surrogation scenario with noise: to use the Dataset $\mathcal{D}^{1, \sigma}_n$, lines 11 and 12 must be set as:
  ```sh
    D  = D_l_n;
    p  = p_l;
   ```
  - Modeling scenario with no noise: to use the Dataset $\mathcal{D}^{2, 0}_n$, lines 11 and 12 must be set as:
  ```sh
    D  = D_nl_nn;
    p  = p_nl;
   ```
  - Modeling scenario with noise: to use the Dataset $\mathcal{D}^{2, \sigma}_n$, lines 11 and 12 must be set as:
  ```sh
    D  = D_nl_n;
    p  = p_nl;
   ```
To average the random noise effect, the script performs 30 repetitions (line 6):
```sh
for seed=1:30
```
In scenarios with no noise, all the repetitions are identical. Then, it is convenient to perform only 1 repetition by setting line 6 as:
```sh
for seed=1:1
```
According to the selected scenario, the script will save 2 files:
- ZKPM_X_X containing the evalutation of MAE is interpolation $[0,t_m]$ and extrapolation $(t_m, t_f]$, for each repetition of the selected scenario 
- ZKris_X_X containing the predicted $u(t)$ of the last repetition

-->
