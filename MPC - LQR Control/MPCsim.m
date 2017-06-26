%%command line simulation


%%%THIS IS WRONG???? MPC performs worse than no control



%T = 0.002
sim_time = 25; %run simulation for sim_time secs
time = [0:T:sim_time]'; %time vector

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

%%Simulating
%reference signal
ref = zeros(length(time),2);

%simulation options
SimOptions = mpcsimopt(mpc1);
SimOptions.Unmeas = disturbance; % unmeasured input disturbance signal
  
%SimOptions.OutputNoise=.001*(rand(Tf,1)-.5);    % output measurement noise
%SimOptions.InputNoise=.05*(rand(Tf,1)-.5);      % noise on manipulated variables

[y,t,u,xp] = sim(mpc1,length(time)*(T/control_sample_T),ref,[],SimOptions);

%%Visualizing output
U = [disturbance ref(:,1)];
[Y, t, x] = lsim(PLANT,U,time);

%Y1
figure, plot(time,roadBump);
hold on
plot(time,y(:,1));
%plot(time,Y(:,1));
legend('z_r','Suspension travel'); %,'Uncontrolled')
title('Plant suspension travel with MPC')
xlabel('Time (sec)')
ylabel('displacement (m)')
hold off

%Y2
figure; %, plot(time,disturbance);
hold on
plot(time,y(:,2));
%plot(time,Y(:,2));
legend('car body acceleration'); %,'uncontrolled'); %'z_rdot',
title('Plant car body acceleration with MPC')
xlabel('Time (sec)')
ylabel('Acceleration (m/s^2)')
hold off

figure;
plot(time, Y(:,1));

figure;
plot(time, Y(:,2));


%%Optimal horizon control
%....