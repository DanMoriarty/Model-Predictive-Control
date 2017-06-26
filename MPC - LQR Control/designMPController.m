%
%
%
%
% Jack Hopper
% 11 May 2017
%
%
%
% Design an MPC controller.
% Run linearRegression script first.
%
%


%Build predictor equaiton.
N = 4; % The horizon length.

Bd_prime = Bd(:,2);

%X = Phi*x0+Gamma*U
m  = size(Ad,1);
n  = size(Ad,2);
n2 = size(Bd_prime,2);

Phi   = zeros(N*m,n);
Gamma = zeros(N*m,N*n2);

for i=1:N
   Phi((i-1)*m+1:i*m,:) = Ad^i;
end


for i=1:N
    for j=i:N
        Gamma((j-1)*m+1:j*m, (i-1)*n2+1:i*n2) = Ad^(j-1)*Bd_prime;
    end
    
end


%Build constraint equations.
D_curl = zeros((N+1)*2*n+N*2*n2, n);
M_curl = zeros((N+1)*2*n+N*2*n2, N*n);
Eps    = zeros((N+1)*2*n+N*2*n2, N*n2);
c      = zeros((N+1)*2*n+N*2*n2, 1);
%D_curl*x0 + M_curl*X + Eps*U <= f

M = zeros(2*n,n);
M(1,1) =  1;
M(2,1) = -1;
M(3,2) =  1;
M(4,2) = -1;

G = M; %Terminal state constraints.

E = zeros(2*n2,n2);
E(1,1) =  1;
E(2,1) = -1;

c_xpart = [0.01;
          0.01;
          0.2;
          0.2;
          0;
          0;
          0;
          0];
      
c_upart = [4;
           4];

D_curl(1:2*n, :) = M;

for i=2:N
    M_curl((i-1)*2*n+1:i*2*n,(i-2)*n+1:(i-1)*n) = M;
end
M_curl(N*2*n+1:(N+1)*2*n, (N-1)*n+1:N*n) = G; %Terminal state constraints

for i=1:N
    start_ind = (N+1)*2*n;
    
    Eps(start_ind+(i-1)*2*n2+1:start_ind+i*2*n2, (i-1)*n2+1:i*n2) = E;
end

c(1:2*n,1) = c_xpart; %initial state constraint.
for i=1:N
    c(i*2*n+1:(i+1)*2*n,1) = c_xpart; %State constraints, including terminal.
end

for i=1:N
    start_ind = (N+1)*2*n;
    c(start_ind+(i-1)*2*n2+1:start_ind+i*2*n2,1) = c_upart;
end

%Build objective function.
%Q = eye(4);
Q = diag([20 50 1 1]);
%P = eye(4);
P = Q;
R = 1;

Omega = zeros(N*n,N*n);
Psi   = zeros(N*n2,N*n2);

for i=1:N-1
    Omega((i-1)*n+1:i*n,(i-1)*n+1:i*n) = Q;
end
Omega((N-1)*n+1:N*n,(N-1)*n+1:N*n) = P;

for i=1:N
    Psi((i-1)*n2+1:i*n2,(i-1)*n2+1:i*n2) = R;
end

%Formulate for quadratic program solver
x0 = x(1,:).';

%Ojective function
F = 2*Gamma.'*Omega*Phi;
G = 2*(Psi + Gamma.'*Omega*Gamma);
%(1/2)*U.'*G*U + U.'*F*x0;

%Constraints
J = M_curl*Gamma+Eps;
W_curl = -1*M_curl*Phi-D_curl;
%J*U <= c + W_curl*x0;

U = quadprog(G,F*x0,J,c+W_curl*x0);


 


