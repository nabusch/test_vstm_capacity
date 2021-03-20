function t_flip = present_empty_screen(win, P, when)

if nargin == 2
    when = [];
end
Screen(win,'FillRect', P.display.bg);

% Draw fixation marker.
my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, ...
    P.display.fix_size, P.display.fix_color, ...
    P.display.bg, P.screen.pixperdeg)

% Do it!  
Screen('DrawingFinished', win);
t_flip = Screen('Flip', win, when);
