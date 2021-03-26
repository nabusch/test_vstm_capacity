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


% --------------------------------------------------------
% Present the feedback.
% --------------------------------------------------------
if P.paradigm.do_feedback
    switch T.correct
        case 1
            my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, ...
                P.display.fix_size, [0 255 0], P.display.bg, P.screen.pixperdeg)
            
        case 0
            my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, ...
                P.display.fix_size, [255 0 0], P.display.bg, P.screen.pixperdeg)
    end
end

Screen('Flip', win);
WaitSecs(P.paradigm.feedback_duration);

