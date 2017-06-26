function sysd = fillStableSS1()
%%%Initializes a state space for system identification, but using
%%%defined parameter relationships; Much slower but greater fidelity than
%%%fillStableSS.m
%% Looping through
sysd = ss([1],[1],[1],[1]);
syms ms mus ks kus bs bus
a1=ks/ms;
a2=bs/ms;
a3=ks/mus;
a4=bs/mus;
a5=kus/mus;
a6=(bs+bus)/mus;
b1=1/ms;
b2=bus;
b3=1/mus;
T=0.002;

StartLoop=true;
while ((isstable(sysd)==0)||(StartLoop==true))
    StartLoop=false;
    bs = rand(1,1)*10^round((rand(1)/2)*10);
    bus = rand(1,1)*10^round((rand(1)/2)*10);
    ms = rand(1,1)*10^round(1-rand(1)*4);
    mus = rand(1,1)*10^round(1-rand(1)*4);
    ks = rand(1,1)*10^round((rand(1)/2)*10);
    kus = rand(1,1)*10^round((rand(1)/2)*10);
    
    a1=ks/ms;
    a2=bs/ms;
    a3=ks/mus;
    a4=bs/mus;
    a5=kus/mus;
    a6=(bs+bus)/mus;
    b1=1/ms;
    b2=bus;
    b3=1/mus;
    A=[0 1 T -1;-T*a1 1-T*a2 0 T*a2;0 0 0 T;T*a3 T*a4 1-T*a5 T*a6];
    B=[0 0; 0 T*b1; -T 0; T*b2 T*b3];
    C=[1 0 0 0; -T*a1 1-T*a2 0 T*a2];
    D=[0 0; 0 T*b1];
    %K=[0.001 0.001;0.001 0.001; 0.001 0.001; 0.001 0.001]
    %eig(A);
    sysd=ss(A,B,C,D,0.002);
end
bs
bus
ks
kus
ms
mus