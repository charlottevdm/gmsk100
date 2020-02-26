close all
clear

% Script to check the properties of a VGA with n-bit resistor feedback

%% Settings
log_scale = 0;

v_low = 0.001;
v_high = 0.1;
v_end = 3.3;
bits = 2;

%% SCRIPT LIN GAIN SCALE

% max_gain = v_end/v_low;
% min_gain = v_end/v_high;
% 
% interval = linspace(min_gain, max_gain, 2^bits);
% interval_voltages = v_end./interval;
% 
% threshold = interval + (interval(2)-interval(1))/2;
% threshold_voltages = v_end./threshold;
% 
% largest_error = ((threshold_voltages .* interval)/v_end); 
% 
% figure;plot(largest_error);ylabel = 'percentage';title('LIN GAIN SCALE')

%% SCRIPT LIN VOLTAGE SCALE

interval = linspace(v_low, v_high, 2^bits);

threshold = interval(1:end-1) + (interval(2)-interval(1))/2;
gain = v_end./threshold;

input = v_low:0.0001:v_high;
error = zeros(size(input));

j = 1;
for i = 1:size(error, 2)
    if j ~= size(threshold, 2)
        if input(i) > threshold(j)
            j = j+1;
        end
    end
    error(i) = input(i)/threshold(j); %percentage
end
figure;
plot(input, error)

