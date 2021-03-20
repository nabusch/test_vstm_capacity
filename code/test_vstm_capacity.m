
Screen('CloseAll');
addpath('./functions');


%% ----------------------------------------------------------------
% Unify KbNames, normalize color range, Assert openGL
%--------------------------------------------------------------------------
PsychDefaultSetup(2);


%% ----------------------------------------------------------------
% Get subject input
%--------------------------------------------------------------------------
q = {'Subject number', 'Gender', 'Glasses/contacts',...
    'Age', 'Dominant eye'};
def = {'99', 'F', '1', '99', 'R'};
answer = inputdlg(q, 'Welcome!', [1,40], def);
INFO.name              = sprintf('%s%s', answer{1});
INFO.id                = str2double(answer{1});
INFO.sex               = answer{2};
INFO.visioncorrected   = answer{3};
INFO.age               = answer{4};
INFO.dominanteye       = answer{5};
INFO.logfilename       = ['logs' filesep INFO.name '_Logfile.mat'];
INFO.P = get_params();


%% ----------------------------------------------------------------
% Test if logfile exists for this subject.
% If yes, confirm to overwrite or quit.
% -------------------------------------------------------------------------
if INFO.id ~= 99
    INFO.continuesubject = false;
    [IsQuit, INFO.continuesubject] = TestLogfile(INFO);
    if IsQuit
        CloseAndCleanup(INFO.P)
        return
    end
end

%% ----------------------------------------------------------------
% Define what do do on each trial.
% -------------------------------------------------------------------------
INFO = define_trials(INFO);


%% ----------------------------------------------------------------
% Open & configure display and set priority.
% -------------------------------------------------------------------------
PsychImaging('PrepareConfiguration');
Screen('Preference', 'SkipSyncTests', INFO.P.setup.skipsync);

if isunix
    Screen('ConfigureDisplay', 'Scanout', INFO.P.screen.screen_num, 0,...
        INFO.P.screen.width, INFO.P.screen.height, INFO.P.screen.rate);
else
    Screen('Resolution', INFO.P.screen.screen_num, INFO.P.screen.width, ...
        INFO.P.screen.height, INFO.P.screen.rate);
end

% if INFO.P.setup.debugwincfg
%     PsychDebugWindowConfiguration
% end

[win, winrect] = PsychImaging('OpenWindow', ...
    INFO.P.screen.screen_num, INFO.P.display.bg);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 2);
INFO.P.screen.ifi = 1.0 / Screen('NominalFramerate', win);

Priority(MaxPriority(win));
% HideCursor;



%% ----------------------------------------------------------------
% Initialize Gamepad
% -------------------------------------------------------------------------
% if INFO.P.setup.isPad
%     INFO.P.setup.padh = HebiJoystick(1);
%     if ~strcmp(INFO.P.setup.padh.Name, INFO.P.setup.PadType)
%         sca;
%         error(['Did not detect a Logitech F310 in D-Mode. ',...
%             'Wrong/multiple Gamepad/s connected?)']);
%     end
% end
%
% % alternate dpad and buttons depending on the subject number
% INFO.P.pad.isDpad = mod(INFO.id, 2);
% if INFO.P.pad.isDpad
%     INFO.P.pad.Up = INFO.P.pad.dpadUp;
%     INFO.P.pad.Down = INFO.P.pad.dpadDown;
% else
%     INFO.P.pad.Up = INFO.P.pad.y;
%     INFO.P.pad.Down = INFO.P.pad.a;
% end


%% ----------------------------------------------------------------
% Instruct subjects (Part 1)
% -------------------------------------------------------------------------
% inst1_time = Instructions(win, INFO);
wrtimg(win, INFO.P);


%% ----------------------------------------------------------------
% Run across real trials.
% -------------------------------------------------------------------------
msg = sprintf('Now running %i trials:', length(INFO.T));
fprintf('\n%s\n\n', msg);

INFO.tStart = {datestr(clock)};

for trial_idx = 1:length(INFO.T)
    
    % --------------------------------------------------------------------
    % Present stimuli if desired.
    % --------------------------------------------------------------------
    if INFO.P.paradigm.show_stimuli
        INFO = one_trial(INFO, win, trial_idx);
    end
    
    % --------------------------------------------------------------------
    % Get response if desired.
    % --------------------------------------------------------------------
    if INFO.P.paradigm.get_response
        [INFO, isQuit] = get_response(INFO, win, trial_idx);
    end
    
    % --------------------------------------------------------------------
    % Save results.
    % --------------------------------------------------------------------
    if isQuit==1
        CloseAndCleanup(INFO.P)
        break
    else
        save(INFO.logfilename, 'INFO');
    end
end

%%
correct = [INFO.T.correct];
ss = [INFO.T.setsize];

for i = 1:length(INFO.P.paradigm.setsizes)
    n = INFO.P.paradigm.setsizes(i);
    p = sum(correct & ss==n) / sum(ss==n); 
    K(i) = n * (2*p - 1)
end
%% ----------------------------------------------------------------
% After last trial, close everything and exit.
% -------------------------------------------------------------------------
save(INFO.logfilename, 'INFO');
CloseAndCleanup(INFO.P);
WaitSecs(1);
fprintf('DONE!\n');

%% DONE!

