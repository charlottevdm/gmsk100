close all
clear

% This converts the output of the VGA to an actual value. No clipping
% should occur. More bits --> easier demodulation, but more complicated to
% develop. 

%% SETTINGS
v_top = 2.9;
v_bottom = 0.9;
f = 20000;
fs = 50000;

%% INPUT
% can be changed out for the actual output of the VGA
t = 0:0.000001:0.0001;
v_mid = (v_top + v_bottom)/2;
v_range = (v_top - v_bottom)/2;
input = v_mid + v_range*sin(2*pi*f*t);

% plot(input)

%% DAC
bits = 4;

% discrete_t = linspace(v_bottom, v_top, 2^bits);

step = (v_top - v_bottom)/(2^bits-1);

output = zeros(size(input));

for sample = 1:size(input, 2)
    if input(sample)/step - floor(input(sample)/step) < 0.5
        output(sample) = floor(input(sample)/step)*step;
    else
        output(sample) = ceil(input(sample)/step)*step;
    end
end

%% PLOTS

figure
plot(input)
hold on
plot(output)

figure
plot((input-output)/v_top)
