function output = VGA_model(input, v_low, v_high, v_end, bits)

interval = linspace(v_low, v_high, 2^bits);

threshold = interval(1:end-1) + (interval(2)-interval(1))/2;
gain = v_end./threshold;

%voorlopig 
max_input = max(input);

%find this in the threshold voltages and choose the correct gain
i = 1;
while max_input > threshold(i)
    i = i+1;
end
output = gain(i)*input;
    
end