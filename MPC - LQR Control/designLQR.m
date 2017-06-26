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
%Q = eye(4);
%Q = diag([25 25 1 1]);
%R = 0.1;
%R = 1;

%New Q with T=0.004.
%Q = diag([2 500 1 1]);

%Values close to those used on real plant.
Q = diag([20 20 1 1]);
R = 1;

[K,S,E] = lqr(sysDT, Q, R);
%K = K(2,:);
