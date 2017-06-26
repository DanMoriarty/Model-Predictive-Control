function [m1 zv ze] = systemEst(Zs,Zus,Zr,Fc,Zs1,Zus1,Zr1,Fc1)
%%Use data of a system response to fabricate a state space estimate of the
%%system at hand

%% Data Preprocessing
START=1;
END=length(Zr)-2; %length of our data in training spreadsheet
T=0.002;

%Constructing input and output matrices, these have been calculated from
%difference equations that use the Euler Difference
Y1 = Zs(START:END)-Zus(START:END);%x1
Y2 = (T^-2)*(Zs(START+2:END+2)-2*Zs(START+1:END+1)+Zs(START:END));%Zsdotdot
U1 = Fc(START:END);
U2 = Zr(START+1:END+1);

%Creating the data profile
train = iddata([Y1 Y2],[U1 U2],0.002);
ze = train(1000:14000);
%plot(ze(1:13000))
%detrending the data to give it zero mean for estimation purposes
ze = detrend(ze);
%plot(ze(1:13000))

%% State Space Construction
%Since we can't use least squares, in order to use the SS estimating functions, a template state space
%realization must be formed; it must also be stable
sysd=fillStableSS();
%//sysd=fillStableSS1(); <-Use to make estimates for params that actually
%//relate to m, k, and b values

%Adding structural constraints
%fixing the values within the state space to confer with our model
m1 = idss(sysd.A,sysd.B,sysd.C,sysd.D);
S=m1.structure;
S.a.Free(1,:)=false;
S.a.Free(2,3)=false;
S.a.Free(3,:)=false;
S.b.Free(1,:)=false;
S.b.Free(2,1)=false;
S.b.Free(3,:)=false;
S.c.Free(1,:)=false;
S.c.Free(2,3)=false;
S.d.Free(1,:)=false;
S.d.Free(2,1)=false;
m1.structure=S;

%setting initial states to zero
opt = ssestOptions;
opt.InitialState = 'zero';

%% Estimating
m1 = ssest(ze,m1,opt);
%figure, h = bodeplot(m1)
%showConfidence(h,3) % 3 std (99.7%) confidence region
%figure, showConfidence(stepplot(m1,'b',mi,'r',3),3)

%% Testing the data
%Constructing input output matrices
Y1 = Zs1(START:END)-Zus1(START:END);%x1
Y2 = (T^-2)*(Zs1(START+2:END+2)-2*Zs1(START+1:END+1)+Zs1(START:END));%Zsdotdot
U1 = Fc1(START:END);
U2 = Zr1(START+1:END+1);
%creating the data profile
test = iddata([Y1 Y2],[U1 U2],0.002);
zv = test(1000:14000);
zv = detrend(zv);
set(gcf,'DefaultLegendLocation','best');
%compare(zv,m1);      % perform comparison of simulated output
