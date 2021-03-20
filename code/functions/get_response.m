function [INFO, isQuit] = get_response(INFO, win, trial_idx)

T = INFO.T(trial_idx); % Just for shorthand.
P = INFO.P;

[report, isQuit, secs] = get_buttonpress(P);

if     T.is_foil_on_top == 1 && report == 1
    correct = 0;
elseif T.is_foil_on_top == 1 && report == 2
    correct = 1;
elseif T.is_foil_on_top == 0 && report == 1
    correct = 1;
elseif T.is_foil_on_top == 0 && report == 2
    correct = 0;
else
    correct = 666;
end

T.report  = report;
T.correct = correct;
T.rt      = secs - T.t_probe_on;

INFO.T(trial_idx) = T;