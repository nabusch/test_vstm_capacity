function [ Report, isQuit, secs ] = get_buttonpress(P)

%%
% WaitSecs(0.200);
Report = 0;
isQuit = 0;
keyIsDown = 0;

while Report == 0
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        if keyCode(P.keys.upkey) == 1
            Report = 1;
        end;
        if keyCode(P.keys.downkey) == 1
            Report = 2;
        end;
        if keyCode(P.keys.quitkey) == 1
            Report = 99;; isQuit = 1;
            return;
        end;
    end;
end;
    