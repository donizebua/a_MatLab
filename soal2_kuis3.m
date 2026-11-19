clear;
clc;
close all;

%% 1. System Parameters
A = [1 0;
     0 1];
B = [1 0;
     0 1];

Q = [1 0;
     0 9];
 
R = [2 0;
     0 4];
 
%% 2. Construct Generalized Eigenvalue Matrices

I = [1 0;
     0 1];
 
Z = [0 0;
     0 0];

M = B * R \ B';

F = [I M;
     Z A']
 
G = [A Z;
     -Q I]
 
%% 3. Generalized Eigenvalue and Eigenvector Calculation

[V, D_eig] = eig(G, F);

niu = diag(D_eig);

% Select eigenvalues inside the unit circle
idx = abs(niu) < 1;

niu_stable = niu(idx)
V_stable = V(:, idx)

%% 4. Calculate Riccati Solution (P)
    
V1s = V_stable(1:2, :)
V2s = V_stable(3:4, :)

P = V2s/V1s

%% 5. Calculate LQR Gain (K)

K = (R + B'*P*B)\(B'*P*A)

%% 6. Calculate Closed-Loop Matrix (Acl)

Acl = A - B * K

eig_Acl = eig(Acl)