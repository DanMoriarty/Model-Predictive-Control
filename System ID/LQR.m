%%% Script for creating an LQR and gains from a given state space

%% Establishing the state space model
A=[0 1 0 -1;-0.6 -0.7 0 0.7;0 0 0 1;0.2 0.1 -0.017 -0.076]
B = [0 0 0;0 0.46 0;-1 0 0;0.07 -0.4712 0]
C = [1 0 0 0; -0.6 -0.7 0 0.7;-0.6 -0.7 0 0.7]
D=[0 0 0; 0 0.46 1; 0 0.46 0]

sys=ss(A,B,C,D,0.002)

% alternatively could use a pre-defined state space
% M1 as found by running Main
sys=M1;

%% LQR parameters
% Weighting matrices
R=1;
q1=1;
q2=1;
q3=1;
q4=1;
Q=[q1 0 0 0; 0 q2 0 0; 0 0 q3 0;0 0 0 q4]

[K,S,e] = lqr(sys.a,sys.b,Q,R)