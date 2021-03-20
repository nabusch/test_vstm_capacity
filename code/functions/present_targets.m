function t_flip = present_targets(win, P, T, when)

if nargin == 3
    when = [];
end

% Prepare the display.
[rects, xcoords, ycoords] = PlaceObjectsOnACircle(...
    P.display.item_ecce*P.screen.pixperdeg, ...
    T.setsize, ...
    P.display.item_diam * P.screen.pixperdeg, ...
    P.display.item_diam * P.screen.pixperdeg, ...
    P.screen.cx, ...
    P.screen.cy);

% Clear the display.
Screen(win,'FillRect', P.display.bg);

% Draw fixation marker.
my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, ...
    P.display.fix_size, P.display.fix_color, ...
    P.display.bg, P.screen.pixperdeg)

% Draw target stimuli.
Screen('FillOval', win, T.colors', rects);

% Do it!
Screen('DrawingFinished', win);
t_flip = Screen('Flip', win, when);

