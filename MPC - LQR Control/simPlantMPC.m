%
%
%
%
%
% Jack Hopper
% 14 May 2017
%
%
% Simulates the active suspension experiment plant with an MPC
% controller pluged in.
% MPC controller uses the quadprog MATLAB function to solve the
% optimisation problem.
%

%Daniels code to set up road disturbance.
T = 0.002
sim_time = 25; %run simulation for sim_time secs
time = (0:T:sim_time).'; %time vector

%%Creating the pulse
pulse_width = 0.5;
pulse_period = 3.33;
pulse_leadup = pulse_period-pulse_width;
pulse_amp = 0.01;

roadBump = [];

pulse = [zeros(pulse_leadup/T,1);pulse_amp*ones(pulse_width/T,1)];
while length(roadBump)<=length(time)    
    roadBump=[roadBump;pulse]; %append the pulse signal
end

while length(roadBump)>length(time)
    roadBump(end)=[]; %truncate array
end


%%differentiating
disturbance = roadBump;
disturbance(1,1)=0;
for i=2:length(time)-1
    prev=roadBump(i,1);
    next = roadBump(i+1,1);
    disturbance(i+1,1)=(next-prev)/T;
end

%Simulate
x = zeros(length(time),4);
y = zeros(length(time),2);
u = zeros(length(time),2);

x(1,:) = zeros(1,4); %Initialise state at 0.
u(:,1) = disturbance;

for i=1:length(time)-1
    %MPC in the loop
    %U = quadprog(G,F*x(i,:).',J,c+W_curl*x(i,:).'); %This has a horizon of 4.
    %u(i:i+3,2) = U; %The optimal control input sequence.
    
    %Or LQR controller
    u(i,2) = -1*K*x(i,:).';
    
    %Plant sim
    x(i+1,:) = x(i,:)*Ad.'+u(i,:)*Bd.';
end

y = x*Cd.'+u(1:length(time),:)*Dd.';