function [SYS zv U3] = betterSysEst(Zs,Zus,Zr,Fc,m1,Zs1,Zus1,Zr1,Fc1, alpha)
%%%Supplementary system identitifcation but using the extra modelled disturbance
%% Data Pre-Processing
START=1;
END=length(Zs1)-2; %length of our data in training spreadsheet
T=0.002;


END=END-1; %we must use less data now, if we are to find Y2(k+1)

Y1 = Zs1(START:END)-Zus1(START:END);%x1
Y2 = (T^-2)*(Zs1(START+2:END+2)-2*Zs1(START+1:END+1)+Zs1(START:END));%Zsdotdot
U1 = Fc1(START:END);
U2 = Zr1(START+1:END+1);
END=END-1;
%This is our Y2(k+1)
U3 = (1/T)*(Y2(1+1:END+1)-Y2(1:END));

%truncating our data to match U3
Y1(end)=[];
Y2(end)=[];
Y3 = Y2; 
U1(end)=[];
U2(end)=[];

%% Augmenting our Matrix
%With an extra input, we must augment our matrix

%A stays the same
A=m1.a;

%our states do not use this new input as part of their calculation
B=[0;0;0;0];
B=[m1.b B];

%we have to make a new output, lets make Y3=Y2
C=m1.c(2,:);
C=[m1.c;C];
%scaling Y1
C(1,1)=0.01;

%This is the most important change
D=[m1.d;m1.d(2,:)];
D(2,3)=alpha;

%the new augmented system looks like this:
SYS=ss(A,B,C,D,T)

%% Testing
%creating the data profile
test = iddata([Y1 Y2 Y3],[U1 U2 U3],0.002);
zv = test(1000:14000);
zv = detrend(zv);    % preprocess the validation data
set(gcf,'DefaultLegendLocation','best');
