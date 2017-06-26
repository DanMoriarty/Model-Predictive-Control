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
%data = csvread('datasets/0.3-10Hz at 1N and 0.3-10Hz at 0.01m.csv',2);
data = csvread('0.01-0.5Hz at 10N and 0.5-10Hz at 0.005m.csv',2);

NUM_SAMP = size(data,1); %Number of samples
T = 0.002; %Sample period.

x = zeros(NUM_SAMP, 4); %Sate vector.
u = zeros(NUM_SAMP, 2); %Input vector.

%Construct states, input and output from data.
%x1 = z_s - z_us
x(:,1) = data(:,8) - data(:,6); 

%x2 = z_sdot
x(2:NUM_SAMP,2) = data(2:NUM_SAMP,8) - data(1:NUM_SAMP-1,8); %Backward difference
x(:,2) = x(:,2)/T; %Now it is a velocity approximation. 

%x3 = z_us - z_r
x(:,3) = data(:,6) - data(:,4);

%x4 = z_usdot
x(2:NUM_SAMP,4) = data(2:NUM_SAMP,6) - data(1:NUM_SAMP-1,6); %Backward difference.
x(:,4) = x(:,4)/T; %Now it is a velocity approximation.

%u1 = z_rdot
u(2:NUM_SAMP,1) = data(2:NUM_SAMP,4) - data(1:NUM_SAMP-1,4); %Backward difference.
u(:,1) = u(:,1)/T; %Now it is a velocity approximation.

%u2 = Fc
u(:,2) = data(:,2);

%Perform linear regression.
%Set up matrices.
Psi1 = [x(1:NUM_SAMP-1,:) u(1:NUM_SAMP-1,:)];
Theta1 = zeros(6,1);
Y1 = x(2:NUM_SAMP,2);

%Theta1 = Psi1\Y1;
Theta1 = inv(Psi1.'*Psi1)*Psi1.'*Y1;

Psi2 = [x(1:NUM_SAMP-1,:), u(1:NUM_SAMP-1,:)];
Theta2 = zeros(6,1);
Y2 = x(2:NUM_SAMP,4);

%Theta2 = Psi2\Y2;
Theta2 = inv(Psi2.'*Psi2)*Psi2.'*Y2;

%Construct the discrete time model matrices Ad, Bd, Cd and Dd.
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
  
%Test the model.
sys=ss(Ad,Bd,Cd,Dd,0.002)
[y_model, x_model] = modelDT(x(1,:), u, sys.a,sys.b,sys.c,sys.d);

plot(Y2(:,1))
hold on
plot(y_model(:,2))
test = abs(x-x_model) >= 0.5;

[where_samp, where_sate] = find(test==1);



