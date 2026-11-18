# Discrete LQR Using Generalized Eigenvalue Method

## Overview

Program ini digunakan untuk memperoleh solusi **Discrete Algebraic Riccati Equation (DARE)** melalui pendekatan *generalized eigenvalue problem*. Metode ini digunakan dalam perancangan kontrol **Linear Quadratic Regulator (LQR)** untuk sistem diskrit.

Model awal dinyatakan dalam bentuk *continuous state-space*, kemudian dikonversi menjadi model diskrit menggunakan metode **Tustin (Bilinear Transform)**. Selanjutnya, solusi matriks Riccati \(P\) diperoleh melalui konstruksi matriks \(F\) dan \(G\), perhitungan generalized eigenvalue dan eigenvector, serta pemilihan eigenvector berdasarkan kriteria kestabilan.

## Main Process

### 1. Continuous State-Space Modeling

Sistem direpresentasikan menggunakan persamaan state-space kontinu:


$ \dot{x}(t)=Ax(t)+Bu(t)$


Matriks \(A\) merepresentasikan dinamika internal sistem, sedangkan \(B\) merepresentasikan pengaruh input kontrol terhadap state.

Model dibentuk menggunakan fungsi MATLAB `ss()`.

### 2. Model Discretization

Model kontinu dikonversi menjadi model diskrit menggunakan metode **Tustin (Bilinear Transform)** melalui fungsi `c2d()`.

Transformasi ini menggunakan pendekatan trapezoidal integration dengan hubungan:


$s=\dfrac{2}{T_s}\dfrac{z-1}{z+1}$


Hasil diskritisasi berupa matriks \(A_d\) dan \(B_d\), yang digunakan dalam persamaan:


$x[k+1]=A_dx[k]+B_du[k]$


Parameter \(T_s\) merupakan sampling time atau periode pengambilan sampel sistem.

### 3. LQR Weighting Matrices

Matriks pembobot \(Q\) dan \(R\) ditentukan sebagai parameter optimasi LQR.

- \(Q\): memberikan bobot terhadap penyimpangan state.
- \(R\): memberikan bobot terhadap besarnya input kontrol.

Keduanya digunakan dalam fungsi biaya:

$
J=\sum_{k=0}^{\infty}
\left(x[k]^TQx[k]+u[k]^TRu[k]\right)
$

### 4. Generalized Eigenvalue Pencil

Untuk memperoleh solusi DARE menggunakan pendekatan eigenvector, dibentuk dua matriks berukuran \(2n\times2n\), yaitu \(F\) dan \(G\).

$
F=
\begin{bmatrix}
I&B_dR^{-1}B_d^T\\
0&A_d^T
\end{bmatrix}
$

$
G=
\begin{bmatrix}
A_d&0\\
-Q&I
\end{bmatrix}
$

Kedua matriks tersebut membentuk **generalized eigenvalue pencil** yang dinyatakan melalui persamaan karakteristik:

$
\det(\mu F-G)=0
$

Persamaan ini digunakan untuk memperoleh generalized eigenvalue \(\mu\) dan eigenvector yang bersesuaian.

### 5. Generalized Eigenvalue and Eigenvector Selection

Perhitungan generalized eigenvalue dan eigenvector dilakukan menggunakan fungsi MATLAB:

`eig(G, F)`

Fungsi tersebut menyelesaikan persamaan:

$
GV=\mu FV
$

Untuk konstruksi pencil ini, eigenvalue dipilih berdasarkan kriteria:

$
|\mu|<1
$

Kriteria tersebut menunjukkan eigenvalue yang berada di dalam unit circle (*stable eigenvalues*).

Eigenvector yang bersesuaian kemudian dikumpulkan untuk membentuk matriks:

$
V_s=
\begin{bmatrix}
V_{1s}\\
V_{2s}
\end{bmatrix}
$

### 6. Riccati Solution

Solusi matriks Riccati diperoleh dari blok eigenvector terpilih:

$
\boxed{P=V_{2s}V_{1s}^{-1}}
$

Matriks \(P\) merupakan solusi dari Discrete Algebraic Riccati Equation (DARE):

$
P=A_d^TPA_d
-A_d^TPB_d
(R+B_d^TPB_d)^{-1}
B_d^TPA_d+Q
$

Matriks ini selanjutnya digunakan untuk memperoleh optimal feedback gain \(K\) dalam perancangan kontroler LQR.

## MATLAB Functions

| Function | Description |
|---|---|
| `ss()` | Membentuk model state-space. |
| `c2d()` | Mengonversi model kontinu menjadi model diskrit. |
| `ssdata()` | Mengambil matriks state-space dari objek sistem. |
| `eye()` | Membentuk matriks identitas. |
| `zeros()` | Membentuk matriks nol. |
| `eig()` | Menghitung generalized eigenvalue dan eigenvector. |
| `abs()` | Menghitung magnitudo eigenvalue. |

## Output

Output utama program adalah:

- Matriks \(A_d\) dan \(B_d\): model state-space diskrit.
- Generalized eigenvalue terpilih: eigenvalue yang memenuhi kriteria kestabilan.
- Matriks \(P\): solusi Discrete Algebraic Riccati Equation.

Matriks \(P\) kemudian dapat digunakan untuk menghitung optimal feedback gain LQR:

$
K=(R+B_d^TPB_d)^{-1}B_d^TPA_d
$