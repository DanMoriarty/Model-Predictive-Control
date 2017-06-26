%%LQR Simulation
%run after running designLQR
%run after running MPCsim

%linearRegression
PLANT = ss(Ad, Bd, Cd, Dd, T) %full plant model inc. Z_rdot
plant = sysDT %controllable plant; no Z_rdot knowledge

lsim(PLANT,U,time)%our plant's response

%setting input; input 2 (not actually F_c, but the reference to be 
%added to F_c) is zero;
U = [disturbance ref(:,1)];

%Simulating the LQR
LQRPLANT = PLANT;
LQRPLANT.A = [PLANT.A]-[PLANT.B(:,2)*K] % create open loop LQR model (A-BK)

hold on
lsim(LQRPLANT,U,time) %simulate LQR results
plot(time,roadBump)
ax = gca
ax.YLim = [-0.25,0.25]
legend('roadbump','With LQR','Unaugmented')
title('Plant Output')
