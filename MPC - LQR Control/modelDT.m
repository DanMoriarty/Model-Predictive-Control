%
%
%
% Jack Hopper
% 17 April 2017
%
% Advanced Motion Control
% Laboratory 2 - Model fitting and MPC
%
% Function returns output and states of system.
%


function [ y, x ] = modelDT( x0, u, Ad, Bd, Cd, Dd )
%MODELDT returns output and state of system.
%   Takes DT state space model matrices, initial state and input as input.

 NUM_SAMP = size(u,1);
 NUM_STAT = size(x0, 2);
 x = zeros(NUM_SAMP,NUM_STAT);
 
 x(1,:) = x0;
 
 for k=1:NUM_SAMP-1
     x(k+1,:) = x(k,:)*Ad.' + u(k,:)*Bd.';
 end
 
 y = x*Cd.' + u*Dd.';

end

