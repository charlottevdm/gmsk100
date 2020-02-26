function wave = varsin(fc, time_step, end_t)
f_mod = 1000;
t = 0:time_step:end_t;
amp = 0.05 * sin(2*pi*f_mod*t) + 1;
% amp = 0.05*t;
wave = 0.005 * sin(2*pi*fc*t);
wave = wave.*amp;
end