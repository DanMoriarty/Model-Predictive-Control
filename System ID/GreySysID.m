%%System Identification using Grey model
%Grey model essentially relates our parameters to predefined relationships
%in our case: a1=ks/ms, etc
odefun = 'suspension';
[bs, bus, ks, kus, ms, mus] = fillStableStateSpace()
Ts=0.002
Z=0;
T=0.002;
I=1;
%Z, I, and T are not really parameters but are treated as such to keep in
%place 1's 0's and -1's
%We can't use a pre-structured matrix with the system Identification
%toolbox

parameters = {bs;bus;ks;kus;ms;mus;Z;T;I};
fcn_type = 'cd';

sysnew = idgrey(odefun,parameters,fcn_type);

%limiting which parameters are allowed to be tuned
sysnew.Structure.Parameters(7).Free = false;
sysnew.Structure.Parameters(8).Free = false;
sysnew.Structure.Parameters(9).Free = false;

sysnew.Structure.Parameters(1).Minimum = 0.0001;
sysnew.Structure.Parameters(2).Minimum = 0.0001;
sysnew.Structure.Parameters(3).Minimum = 0.0001;
sysnew.Structure.Parameters(4).Minimum = 0.0001;
sysnew.Structure.Parameters(5).Minimum = 0.0001;
sysnew.Structure.Parameters(6).Minimum = 0.0001;

opt = greyestOptions;
opt.InitialState = 'zero';
opt.DisturbanceModel = 'none';
opt.Focus = 'simulation'
opt.Focus = 'prediction'
sysEst = greyest(ze,sysnew,'Ts', 0.002,opt)
compare(ze,sysEst,'g');


