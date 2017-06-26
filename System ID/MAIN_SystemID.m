%%%System Identification%%%
% System identification for sampled data by finding the best
% continuous-time fit

%% Data pre-processing
%import data (see excel csv files for formatting)

%To determine the best-fitted system, we will creat 10 estimates and choose
%the best-fitted (this will take a while)
SIZE=10;
bestfit1=99999; %some sufficiently large number
bestfit2=99999; %some sufficiently large number

for i=1:SIZE
    %Create the system estimation
    [m1 zv ze]=systemEst(Zs,Zus,Zr,Fc,Zs1,Zus1,Zr1,Fc1);
    %compare it to testing data
    [Y,fit,x0]=compare(zv,m1,'b');
    
    %seeing if m1 is the best-fitted for either output
    if abs(100-fit(1))<bestfit1 
        bestfit1 = fit(1);
        M1=m1;
    end
    if abs(100-fit(2))<bestfit2 
        bestfit2 = fit(2);
        M2=m1;
    end
end

M1;
M2;
%visualizing how well the best-fitted estimations fit our test data
compare(zv,M1,'b')
compare(zv,M2,'r')

%while this data is apparently well-fitted, how can we know that it
%reflects the a and b parameter values accurately

%% ANALYSIS
%%%Analysis of system ID mismatch and identification of possible sources of
%error.


%Note that the above estimates do not correlate entirely with the test data
%with regards to amplitude
%Through tuning, we can augment our state space to fit with the data while
%still complying with our model

%Play with the 0.01 value in the following eqn:
compare(zv,0.01*M1,'b')
%the amplitude is much closer now, but there will always be unavoidable phase delay
%the amplitude of the output can also be changed by scaling down the A
%matrix paramaters

%For Y2 amplitude, controlling it is far more difficult, we can't capture the bulge.
%However, note that the periodic spikes of noise we see in the response
%match up with the period of our estimate

%It seems the spikes are diminished at the peaks of our sinusoidal response
%(where the change of rate of Y2 is 0)
%And likewise amplified at the points where slope is the steepest
%(where the change of rate of Y2 is maximum)

%Hence, we can think of the noise as somehow being related to Y2_dot
%Ideally, our better Y2 estimate,Y2* is:
%Y2*(k)= Y2(k) + alpha*d(k)*Y2(k+1)

%But how do we get this information of Y2(k+1) and validate that our fit 
%resembles our actual system's response under noisy conditions? 

%We can use it the same way we gained information about Zs,Zus,Zr,Fc, and
%most importantly, Zr_dot, by using Euler discretization
[SYS zv U3] = betterSysEst(Zs,Zus,Zr,Fc,m1,Zs1,Zus1,Zr1,Fc1,1);

%Let's visualize this
compare(zv,SYS,'g')
%note the difference between the original Y2 and the new Y2 which is Y3

% We can now keep playing with alpha, and gains on C parameters until we
% get a good fit

%We can now trust that our parameters are fairly accurate and we can take
%stabs at average values for them, provided the then-constructed state spaces are
%stable

%% TL;DR
%The system ID is close.
%The frequency aligns though slight phase lag
%Incorporating an extra measurement, the change in acceleration, and
%modelling the disturbance around this yields a better fit