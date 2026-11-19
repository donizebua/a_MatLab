
clear;
clc;
close all;

%% 1. System Parameters

A = 1;
B = 0.5;

Q = 2;
R = 1;

%% 2. Construct Generalized Eigenvalue Matrices

I = 1;
Z = 0;

M = B * (1/R) * B';

F = [I M;
     Z A'];

G = [A Z;
     -Q I];

%% 3. Generalized Eigenvalue and Eigenvector Calculation

[V, D_eig] = eig(G, F);

niu = diag(D_eig);

% Select eigenvalues inside the unit circle
idx = abs(niu) < 1;

niu_stable = niu(idx);
V_stable = V(:, idx);

%% 4. Calculate Riccati Solution (P)

V1s = V_stable(1, :);
V2s = V_stable(2, :);

P = V2s / V1s;

%% 5. Calculate LQR Gain (K)

K = (R + B' * P * B) \ (B' * P * A);

%% 6. Calculate Closed-Loop Matrix (Acl)

Acl = A - B * K;

%% 7. Display Results

disp('Selected Eigenvalues:');
disp(niu_stable);

disp('Riccati Solution P:');
disp(real(P));

disp('LQR Gain K:');
disp(real(K));

disp('Closed-Loop Matrix Acl:');
disp(real(Acl));
