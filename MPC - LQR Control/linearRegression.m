%
%
%
% Jack Hopper
% 17 April 2017
% 
% Advanced Motion Control
% Laboratory 2 - Model fitting and MPC
%
%

%Read in a data set to use to perform linear regression to fit the model.
T = 0.002; %Sample period.
data_file_string = 'datasets/0.3-10Hz at 1N and 0.3-10Hz at 0.01m.csv';

%data = csvread('datasets/0.01-0.5Hz at 10N and 0.5-10Hz at 0.005m.csv',2);
%data = csvread('datasets/10N step and 0.1-1Hz at 0.01m.csv',2);

[ x, u ] = constructStateData( data_file_string, T );
NUM_SAMP = size(x,1);

%Perform linear regression.
%Set up matrices.
Psi1 = [x(1:NUM_SAMP-1,:) u(1:NUM_SAMP-1,:)];
%Psi1 = [x(1:NUM_SAMP-1,1:2) x(1:NUM_SAMP-1,4) u(1:NUM_SAMP-1,2)];
Theta1 = zeros(6,1);
Y1 = x(2:NUM_SAMP,2);

Theta1 = Psi1\Y1;
%Theta1 = inv(Psi1.'*Psi1)*Psi1.'*Y1;

Psi2 = [x(1:NUM_SAMP-1,:), u(1:NUM_SAMP-1,:)];
Theta2 = zeros(6,1);
Y2 = x(2:NUM_SAMP,4);

Theta2 = Psi2\Y2;
%Theta2 = inv(Psi2.'*Psi2)*Psi2.'*Y2;

%
%Find the parameters a1 a2 a3 a4 a5 a6 b1 b2 b3.
parameters1 = Theta1 - [0;
                        1;
                        0;
                        0;
                        0;
                        0];
parameters1 = parameters1/T;

parameters2 = Theta2 - [0;
                        0;
                        0;
                        1;
                        0;
                        0];
parameters2 = parameters2/T;

%Construct the continuous time system matrices
a1 = -1*parameters1(1,1);
a2 = (-1*parameters1(2,1)+parameters1(4,1))/2; %avg.
a3 = parameters2(1,1);
a4 = parameters2(2,1);
a5 = -1*parameters2(3,1);
a6 = -1*parameters2(4,1);
b1 = parameters1(6,1);
b2 = parameters2(5,1);
b3 = -1*parameters2(6,1);

%{
A = [0   1   0  -1; 
    -a1 -a2  0  a2;
     0   0   0   1;
     a3  a4 -a5 -a6];
B = [0   0;
     0   b1;
    -1   0;
     b2 -b3];
C = [1   0   0   0;
    -a1 -a2  0  a2];
D = [0 0;
     0 b1];
 
sys = ss(A,B,C,D);
sysDT = c2d(sys, T,'zoh')
[Ad, Bd, Cd, Dd] = ssdata(sysDT);
%} 
 
%Construct the discrete time model matrices Ad, Bd, Cd and Dd.
%
Ad = [1 T 0 -T;
      Theta1(1:4,1).';
      0 0 1  T;
      Theta2(1:4,1).'];



 
Bd = [0 0;
      Theta1(5:6,1).';
      -T 0;
      Theta2(5:6,1).'];


Cd = [1 0 0 0;
     Theta1(1:4,1).'];


Dd = [0 0;
      Theta1(5:6,1).'];
%}

%{
Ad = [1 T 0 -T;
      Theta1(1:2,1).', 0, Theta1(3,1);
      0 0 1  T;
      Theta2(1:4,1).'];

Bd = [0 0;
      0, Theta1(4,1);
      -T 0;
      Theta2(5:6,1).'];
  
Cd = [1 0 0 0;
     Theta1(1:2,1).', 0, Theta1(3,1)];

Dd = [0 0;
      0, Theta1(4,1)]; 
%}


 
%Test the model.
data_file_string = 'datasets/0.01-0.5Hz at 10N and 0.5-10Hz at 0.005m.csv';
[ x, u ] = constructStateData( data_file_string, T );

[y_model, x_model] = modelDT(x(1,:), u, Ad, Bd, Cd, Dd);

test = abs(x-x_model) >= 0.5;

[where_samp, where_sate] = find(test==1);

figure(1)
plot(u(:,1));

figure(2)

subplot(4,1,1);
plot(x_model(1:8000,1),'b');
hold on
plot(x(1:8000,1),'r');

ylabel('State 1');
set(gca, 'fontSize', 16);
title('Model and real system states - new input', 'fontsize', 22);

subplot(4,1,2);
plot(x_model(1:8000,2),'b');
hold on
plot(x(1:8000,2),'r');

ylabel('State 2');
set(gca, 'fontSize', 16);

subplot(4,1,3);
plot(x_model(1:8000,3),'b');
hold on
plot(x(1:8000,3),'r');

ylabel('State 3');
set(gca, 'fontSize', 16);

subplot(4,1,4);
plot(x_model(1:8000,4),'b');
hold on
plot(x(1:8000,4),'r');

ylabel('State 4');
xlabel('Samples');
set(gca, 'fontSize', 16);
legend('Model', 'Real sys')

