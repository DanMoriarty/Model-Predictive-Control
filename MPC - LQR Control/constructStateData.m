%
%
%
% Jack Hopper 
% 06 May 2017
%
%
%



function [ x, u ] = constructStateData( data_fil_name, T )
%CONSTRUCTSTATEDATA Summary of this function goes here
%   Detailed explanation goes here
    
    %Read in a data set to use to perform linear regression to fit the model.
    data = csvread(data_fil_name,2);

    NUM_SAMP = size(data,1); %Number of samples
    T; %Sample period.

    x = zeros(NUM_SAMP, 4); %Sate vector.
    u = zeros(NUM_SAMP, 2); %Input vector.

    %Construct states, input and output from data.
    %x1 = z_s - z_us
    x(:,1) = data(:,8) - data(:,6); 

    %x2 = z_sdot
    x(2:NUM_SAMP,2) = data(2:NUM_SAMP,8) - data(1:NUM_SAMP-1,8); %Backward difference
    x(:,2) = x(:,2)/T; %Now it is a velocity approximation. 

    %x3 = z_us - z_r
    x(:,3) = data(:,6) - data(:,4);

    %x4 = z_usdot
    x(2:NUM_SAMP,4) = data(2:NUM_SAMP,6) - data(1:NUM_SAMP-1,6); %Backward difference.
    x(:,4) = x(:,4)/T; %Now it is a velocity approximation.

    %u1 = z_rdot
    u(2:NUM_SAMP,1) = data(2:NUM_SAMP,4) - data(1:NUM_SAMP-1,4); %Backward difference.
    u(:,1) = u(:,1)/T; %Now it is a velocity approximation.

    %u2 = Fc
    u(:,2) = data(:,2);

    %LPF x and u because finite difference velocity approximation might not
    %work very well.
    x(:,2) = smooth(x(:,2),10);
    x(:,4) = smooth(x(:,4),10);
    u(:,1) = smooth(u(:,1),10);

end

