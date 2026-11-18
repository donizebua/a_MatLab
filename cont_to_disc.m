
clear;
clc;
close all;

%% 1. Continuous State-Space Model

A = [0  1;
    -2 -0.5];

B = [0;
     1];

C = [1 0];
D = 0;

sys_c = ss(A, B, C, D);


%% 2. Continuous-to-Discrete Conversion (Tustin)

Ts = 0.05;

sys_d = c2d(sys_c, Ts, 'tustin');

[Ad, Bd, Cd, Dd] = ssdata(sys_d);

disp('Discrete A matrix:');
disp(Ad);

disp('Discrete B matrix:');
disp(Bd);


%% 3. LQR Weighting Matrices

Q = [10  0;
      0  1];

R = 1;


%% 4. Constructing the Generalized Eigenvalue Pencil

I = eye(2);
Z = zeros(2, 2);

M = Bd * (1/R) * Bd';

F = [I  M;
     Z  Ad'];

G = [Ad  Z;
    -Q  I];


%% 5. Generalized Eigenvalue and Eigenvector Calculation

[V, D_eig] = eig(G, F);

niu = diag(D_eig);

% Select eigenvalues inside the unit circle
idx = abs(niu) < 1;

niu_stable = niu(idx);
V_stable = V(:, idx);


%% 6. Recovering the Riccati Solution

V1s = V_stable(1:2, :);
V2s = V_stable(3:4, :);

P = V2s / V1s;

disp('Selected eigenvalues:');
disp(niu_stable);

disp('Riccati solution P:');
disp(real(P));
