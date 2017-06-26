%Read in a data set to use to perform linear regression to fit the model.
%data = csvread('datasets/0.3-10Hz at 1N and 0.3-10Hz at 0.01m.csv',2);
data = csvread('0.01-0.5Hz at 10N and 0.5-10Hz at 0.005m.csv',2);

NUM_SAMP = size(data,1); %Number of samples
T = 0.002; %Sample period.

x = zeros(NUM_SAMP, 4); %Sate vector.
u = zeros(NUM_SAMP, 2); %Input vector.
y = zeros(NUM_SAMP, 2);

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

%y1 = x1
y(:,1)=x(:,1);

%y2 = x2dot
y(2:NUM_SAMP,2) = data(3:NUM_SAMP,8) - 2*data(2:NUM_SAMP-1,8) + data(1:NUM_SAMP-2,8); %Backward difference
y(:,2) = y(:,2)/T^2; %Now it is a velocity approximation. 

ze=iddata(y,u,0.002)

