%% Clearing
close all;  clear;  clc
addpath util data


%% Input parameters
time_sampling = 0.01;

conditions = "calabrese";

switch conditions
    case "alderisio_group_1"
        adjacency = [0 1 0 0 0 0 1;
                     1 0 1 0 0 0 0;
                     0 1 0 1 0 0 0;
                     0 0 1 0 1 0 0;
                     0 0 0 1 0 1 0;
                     0 0 0 0 1 0 1;
                     1 0 0 0 0 1 0];
        n_particip = size(adjacency, 1);
        gain_coup = 1.25 / n_particip;
        omega_n = [4.2568, 4.3143, 4.6691, 4.2951, 4.3623, 2.9433, 4.2184]';
        index_L2 = 6;
        time_end = 300;
        ampl_spikes   = 0;
    case "alderisio_group_2"
        adjacency = [0 1 0 0 0 0 1;
                     1 0 1 0 0 0 0;
                     0 1 0 1 0 0 0;
                     0 0 1 0 1 0 0;
                     0 0 0 1 0 1 0;
                     0 0 0 0 1 0 1;
                     1 0 0 0 0 1 0];
        n_particip = size(adjacency, 1);
        gain_coup = 4.40 / n_particip;
        omega_n = [2.7151, 2.9299, 4.0344, 2.1476, 3.9117, 3.7429, 3.2827]'; 
        index_L2 = 6;
        time_end = 300;
        ampl_spikes   = 0;
    case "calabrese"
        adjacency = [0 1 0 0 1;
                     1 0 1 0 0;
                     0 1 0 1 0;
                     0 0 1 0 1;
                     1 0 0 1 0];
        n_particip = size(adjacency, 1);
        gain_coup = 1.6;
        omega_n = [3.04, 6.36, 3.34, 9.91, 5.21]';
        index_L2 = 4;
        time_end = 10;
        ampl_spikes   = 0;
    case "calabrese_spikes"
        adjacency = [0 1 0 0 1;
                     1 0 1 0 0;
                     0 1 0 1 0;
                     0 0 1 0 1;
                     1 0 0 1 0];
        n_particip = size(adjacency, 1);
        gain_coup = 1.6;
        omega_n = [3.04, 6.36, 3.34, 9.91, 5.21]';
        index_L2 = 4;
        time_end = 100;     
        ampl_spikes   = 10;
end

theta_0 = zeros(n_particip, 1);

dist_spikes   = 5;
length_spikes = 1;  % s

thres_max = 1 * pi/2;
thres_min = 0.3 * pi/2;
err_max   = 0.3 * pi/2;
speed_thres_descending = 2.5;  % settling time at 1% is approx 5 / speed_thres
speed_thres_ascending = 1;

thres_0 = thres_max;
p_norm = 4; % saturation
w=200;


%% Useful quantities
time_vec = 0 : time_sampling : time_end;
n_samples_time = length(time_vec);

% Communication structure
my_graph      = graph(adjacency);
incidence_mat = full(incidence(my_graph));

freq_sampling = 1/time_sampling;

% frequency generation
spikes = zeros(1, n_samples_time);
spikes(dist_spikes*freq_sampling : dist_spikes*freq_sampling : end) = ampl_spikes; % Impulsi ogni 5 secondi di ampiezza 10
n_samples_spikes = ceil(length_spikes * freq_sampling);
spikes = conv(spikes, triang(n_samples_spikes), 'same'); % Applicazione di una forma d'onda triangolare agli impulsi

freqs_default = omega_n * ones(1, n_samples_time); 
freqs_altered = freqs_default;
freqs_altered(index_L2, :) = freqs_altered(index_L2, :) + spikes;

freqs_signals = timeseries(freqs_altered,time_vec);
freqs_signals.time = time_vec;

action_space_L3 = -0.5 : 0.1 : 0.5;

freq_L3_max = 15;
freq_L3_min = -15;



