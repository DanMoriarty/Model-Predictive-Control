%
%
%
% Jack Hopper
% 23 April 2017
%
% Advanced Motion Control
% Laboratory 2 - Active Suspension system.
%
% Scrip finds the feedback gain matrix, K, using LQR controller design.
%
% Must run the linearRegression script first to obtain the discretised
% model.
%
%


%Set up B and D matrices for input of Fc only. zr_dot is not considered a
%control input.
Bd_prime = Bd(:,2);
Dd_prime = Dd(:,2);

Bd_dist = Bd(:,1);

%Define model of active suspension system.
sysDT = ss(Ad,Bd_prime,Cd,Dd_prime, T); %T is the sample period.

%Set up LQR tuning matrices Q and R.
r2=0.0001;
R=eye(2);
R=[r2];
q1=0;
q2=1;
q3=0;
q4=0;
Q=eye(4);
Q=[q1 0 0 0; 0 q2 0 0; 0 0 q3 0; 0 0 0 q4];

[K,S,E] = lqr(sysDT, Q, R);
K
