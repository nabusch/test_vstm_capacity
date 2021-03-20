function [IsQuit, resume] = TestLogfile(INFO)
% Test if logfile exists.
IsQuit = 0;
resume = false;

if exist(INFO.logfilename, 'file')
    disp('#######################################')
    disp('#######################################')
    asktext = ['File exists: ', INFO.logfilename, '! Overwrite (O), Abort (A) or continue (C)?\n'];

    
    answer = 0;
    
    while answer==0
        r = input(asktext, 's');
        if r=='o'
            decision = 1; % overwrite
            disp('OVERWRITING LOGFILES NOW.')
            answer = 1;
        elseif r=='a' % do not overwrite and quit
            disp('Will not overwrite. Exit programm.')
            answer = 1;
            IsQuit = 1;
        elseif r=='c' % do not overwrite and quit
            disp('Will load user data and attempt to continue...')
            answer = 1;
            IsQuit = 0;
            resume = true;
        end
    end

end  