function output = ADC_model(input, bits, v_top, v_bottom) 

step = (v_top - v_bottom)/(2^bits-1);
output = zeros(size(input));

for sample = 1:size(input, 2)
    if input(sample)/step - floor(input(sample)/step) < 0.5
        output(sample) = floor(input(sample)/step)*step;
    else
        output(sample) = ceil(input(sample)/step)*step;
    end
end


end





