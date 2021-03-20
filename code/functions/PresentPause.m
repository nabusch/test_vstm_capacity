function PresentPause(window, INFO, t)
% Does exactly what the name says.

disp('Pause')
WaitSecs(0.5);

% If we are in the testing room, present a nice image.
% if P.isSerious
%     breakimages = rdir(['..' filesep 'images' filesep '*.png']); %for a random image during breaks
%     breakimages = {breakimages(randperm(numel(breakimages))).name};
%     ima=imread(breakimages{1});           
%     % Screen('DrawTexture', window, EmptyScreen);
%     Screen(window,'FillRect', P.BgColor);
%     Screen('PutImage', window, ima);
% end

P = INFO.P; % just for shorthand
cx = P.screen.cx;
cy = P.screen.cy;


Screen(window,'FillRect', P.display.bg);
pausetext = ['Press spacebar to start trial ' num2str(t) ' of ' num2str(length(INFO.T))];
Screen(window,'TextSize',24);
tw = RectWidth(Screen('TextBounds', window, pausetext));
th = RectHeight(Screen('TextBounds', window, pausetext));

Screen(window,'DrawText', pausetext, cx-0.5*tw, cy-2*th, P.display.fix_color);
% my_fixationpoint(window, P.CenterX, P.CenterY, P.FixSize, P.FixColor)
my_optimal_fixationpoint(window, cx, cy, P.display.fix_size, P.display.fix_color, ...
    P.display.bg, P.screen.pixperdeg)

Screen('Flip', window);

 RestrictKeysForKbCheck(KbName('space'));
[secs, keyCode, deltaSecs] = KbWait();
 RestrictKeysForKbCheck([]);
if keyCode(P.keys.quitkey)
    CloseAndCleanup(P)
end;     
       
WaitSecs(0.5);
fprintf('\n');

WaitSecs(1.5);