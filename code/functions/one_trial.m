function INFO = one_trial(INFO, win, trial_idx)

%%
T = INFO.T(trial_idx); % Just for shorthand.
P = INFO.P;

%% Present empty inter-trial interval.
T.t_trial_on = present_empty_screen(win, P, []);


%% Present targets.
T.t_target_on = present_targets(win, P, T, T.t_trial_on + P.timing.dur_isi);


%% Present delay interval.
T.t_delay_on = present_empty_screen(win, P, T.t_target_on + P.timing.dur_target);


%% Present probe stimuli.
T.t_probe_on = present_probe(win, P, T, T.t_delay_on + P.timing.dur_delay);


INFO.T(trial_idx) = T;