function [A,B,C,D] = suspension(bs,bus,ks,kus,ms,mus,Z,T,I,Ts)
%%%Parameter setting for Greybox estimation
%% Defining parameter relationships
a1=ks/ms;
a2=bs/ms;
a3=ks/mus;
a4=bs/mus;
a5=kus/mus;
a6=(bs+bus)/mus;
b1=1/ms;
b2=bus;
b3=1/mus;

%% Defining strucured (discrete time) state space
%T is sample period
%I represents 1
%Z represents 0
A=[I T Z -T;-T*a1 1-a2*T Z T*a2;Z Z I T;T*a3 T*a4 -T*a5 1-T*a6];
B=[Z Z; Z T*b1; -T Z; T*b2 -T*b3];
C=[I Z Z Z; -T*a1 1-a2*T Z T*a2];
D=[Z Z; Z T*b1];

sys1 = ss(A,B,C,D,0.002);
end 