clear
close all

%% SETTINGS
fc = 20000;
% input settings
v_low = 0.001;
v_high = 0.1;
end_t = 0.001;
time_step = 0.000001;

% vga settings
bits_vga = 6;

% adc settings
bits_adc = 3;
v_adc_top = 2.9;
v_adc_bottom = 0.9;

%% INPUT SIGNAL

input_signal = varsin(fc, time_step, end_t);

%% VGA

output_vga = VGA_model(input_signal, v_low, v_high, v_adc_top, bits_vga);


%% ADC

output_adc = ADC_model(output_vga, bits_adc, v_adc_top, v_adc_bottom);

%% PLOTS
figure
plot(input_signal)
hold on 
plot(output_vga)
hold on
plot(output_adc)
legend('input signal', 'output vga', 'output adc')

figure
title('Error plot between input and output of the VGA');
plot(output_vga - output_adc)

