function sysd = fillStableSS()
%%%Initializes a state space for system identification
sysd = ss([1],[1],[1],[1]);
StartLoop=true;
T=0.002;
while ((isstable(sysd)==0)||(StartLoop==true))
    StartLoop=false;
    %Choose random values for params to initialize our to-be-tuned matrices
    %We put constraints on the orders of magnitude that tehse could be
    a1 = rand(1,1)*10^round(5-rand(1)*10);
    a2 = rand(1,1)*10^round(5-rand(1)*10);
    a3 = rand(1,1)*10^round(5-rand(1)*10);
    a4 = rand(1,1)*10^round(5-rand(1)*10);
    a5 = rand(1,1)*10^round(5-rand(1)*10);
    a6 = rand(1,1)*10^round(5-rand(1)*10);
    b1 = rand(1,1)*10^round(2-rand(1)*10);
    b2= rand(1,1)*10^round(5-rand(1)*10);
    b3 = rand(1,1)*10^round(-rand(1)*10);
A=[0 1 T -1;-T*a1 1-T*a2 0 T*a2;0 0 0 T;T*a3 T*a4 1-T*a5 T*a6];
B=[0 0; 0 T*b1; -T 0; T*b2 T*b3];
C=[1 0 0 0; -T*a1 1-T*a2 0 T*a2];
D=[0 0; 0 T*b1];
%K=[0.001 0.001;0.001 0.001; 0.001 0.001; 0.001 0.001]
%eig(A);
sysd=ss(A,B,C,D,T);
end