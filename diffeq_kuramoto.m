function phases_next = diffeq_kuramoto(phases, freqs, gain_coup, incidence_mat, time_sampling)

phases_next = phases + time_sampling * (freqs + gain_coup * incidence_mat * sin (- incidence_mat' * phases));

end
