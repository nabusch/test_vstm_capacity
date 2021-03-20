function t_flip = present_probe(win, P, T, when)

if nargin == 3
    when = [];
end

% Calculate again the x/y coordinates of the targets.
[rects, xcoords, ycoords] = PlaceObjectsOnACircle(...
    P.display.item_ecce*P.screen.pixperdeg, ...
    T.setsize, ...
    P.display.item_diam * P.screen.pixperdeg, ...
    P.display.item_diam * P.screen.pixperdeg, ...
    P.screen.cx, ...
    P.screen.cy);

% Get the x/y coordinates of the to-be-tested item and calculate the rects
% for the probes.
x = xcoords(T.itest);
y = ycoords(T.itest);

bottom_rect = [...
    x-0.25*P.display.item_diam*P.screen.pixperdeg, ...
    y, ...
    x+0.25*P.display.item_diam*P.screen.pixperdeg, ...
    y+0.5*P.display.item_diam*P.screen.pixperdeg];

top_rect = [...
    x-0.25*P.display.item_diam*P.screen.pixperdeg, ...
    y-0.5*P.display.item_diam*P.screen.pixperdeg, ...
    x+0.25*P.display.item_diam*P.screen.pixperdeg, ...
    y];


% Clear the display.
Screen(win,'FillRect', P.display.bg);

% Draw fixation marker.
my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, ...
    P.display.fix_size, P.display.fix_color, ...
    P.display.bg, P.screen.pixperdeg)


% Show the original target circle too for comparison, eg. for debugging.
% Screen('FillRect', win, T.colors',         rects);


% Draw target and foil probe.
if T.is_foil_on_top == 1
    %     Screen('FillOval', win, [T.foil_color; T.colors(T.itest,:)]',     [top_rect; bottom_rect]');
    Screen('FillArc', win, T.foil_color',        rects(:,T.itest), 270, 180)
    Screen('FillArc', win, T.colors(T.itest,:)', rects(:,T.itest),  90, 180)
else
    %     Screen('FillOval', win, [T.colors(T.itest,:); T.foil_color]',     [top_rect; bottom_rect]');
    Screen('FillArc', win, T.foil_color',        rects(:,T.itest), 90, 180)
    Screen('FillArc', win, T.colors(T.itest,:)', rects(:,T.itest),  270, 180)
end

% Do it!
Screen('DrawingFinished', win);
t_flip = Screen('Flip', win, when);
