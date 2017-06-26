%%Creating parameters for our MPC%%

%run linear regression first
linearRegression;

PLANT = ss(Ad, Bd, Cd, Dd, T);

%%inputs
%unmeasured disturbance
Z_rdot = u(:,1);

%measured input
Fc = u(:,2);

%%Outputs
%Mesured outputs
Y1;
Y2;

%%MPC Design
%mpcDesigner

%Want controller to sample faster than the plant
control_sample_T = 0.002

%setting MPC variables
PLANT.InputName = {'Z_r_dot','F_c'};
PLANT.OutputName = {'y1','y2'};
PLANT.StateName = {'x1','x2','x3','x4'};

%setting channels
PLANT.InputGroup.MV = 2; %setting Manipulated Var as u2
PLANT.InputGroup.UD = 1; %setting Unmeasured Disturbance as u1
PLANT.OutputGroup.MO = [1, 2]; %setting measured outputs as Y1 Y2

%'direct feedthrough' is not allowed, can't have non-zero D
PLANT.d = zeros(2,2);

%Designing the mpc object
mpc1 = mpc(PLANT,control_sample_T);    

%Run this after configuring the mpc controller 
%(setting a default initial state for the sake of simulation)
initState = mpcstate(mpc1);

%......now ready to run mpcsim

