function P = get_params()

%% Set the computer-specific parameters.
switch computername
    case {'x1yoga', 'busch02', 'busch01', 'lbusch01', 'wanjas-yoga-2-pro', 'franzis-x1'}
        
        thescreen = max(Screen('Screens'));
        myres = Screen('Resolution', thescreen);
        
        P.screen.screen_num   = thescreen;%max(nscreens); 0 is you have only one screen (like a laptop) 1 or 2 if you have multiple screens one is usually the matlab screen
        P.screen.width        = myres.width;
        P.screen.height       = myres.height;
        P.screen.rate         = myres.hz;
        P.screen.size         = [36 27]; %screen size in centimeters.
        P.screen.viewdist     = 55; % distance between
        
        P.setup.isEEG         = 0;
        P.setup.isET          = 0;
        P.setup.isPad         = 1;
        P.setup.PadType       = 'Logitech Dual Action';%'Logitech Gamepad F310';%'  PC Game Controller';
        P.setup.skipsync      = 1;
        P.setup.useCLUT       = 0;
        P.trackr.dummymode    = 0; 
        P.setup.debugwincfg   = 0;
        P.setup.screenshots   = 0;
                
    case {'BUSCHLAB1', 'buschstim'}
        P.screen.screen_num   = 1;
        P.screen.width        = 1920;
        P.screen.height       = 1080;
        P.screen.rate         = 120;
        P.screen.size         = [52.2 29.4]; %screen size in centimeters.
        P.screen.viewdist     = 86; % distance between
        
        P.setup.isEEG         = 1;
        P.setup.isET          = 1;
        P.setup.isPad         = 1;
        P.setup.PadType       = 'Logitech Logitech Dual Action';
        P.setup.skipsync      = 0;
        P.setup.useCLUT       = 0;
        P.trackr.dummymode    = 0;
        P.setup.debugwincfg   = 0;
        P.setup.screenshots   = 0;
        assert(all([P.setup.isEEG, P.setup.isET, ~P.setup.skipsync,...
            ~P.setup.screenshots]))
end


%% ------------------------------------------------------------------------
%  Parameters of the screen.
%  Calculate size of a pixel in visual angles.
% ------------------------------------------------------------------------
P.screen.cx = round(P.screen.width/2); % x coordinate of screen center
P.screen.cy = round(P.screen.height/2); % y coordinate of screen center

[P.screen.pixperdeg, P.screen.degperpix] = VisAng(P);
P.screen.pixperdeg = mean(P.screen.pixperdeg);
P.screen.degperpix = mean(P.screen.degperpix);

P.screen.white = WhiteIndex(P.screen.screen_num);
P.screen.black = BlackIndex(P.screen.screen_num);
P.screen.ifi_buffer = 0.5;


%% ------------------------------------------------------------------------
%  Paradigm
%  ------------------------------------------------------------------------
P.paradigm.do_feedback = 1;
P.paradigm.feedback_duration = 0.200;
P.paradigm.Feedbackthick = 0.1; %degree
P.paradigm.setsizes = [4 7];% 4 7];
P.paradigm.breakafter = 20; %break after n trials
P.paradigm.n_training_trials = 15;% how many training trials?
P.paradigm.n_trials = 40; % n trials per set size
P.paradigm.jitter_colors = 0;

P.paradigm.show_stimuli = 1; % Set to zero to skip stimulus presentation for testing.
P.paradigm.get_response = 1; % Set to zero to skip response and simulate result. 


%% ------------------------------------------------------------------------
%  Timing
%  ------------------------------------------------------------------------
P.timing.dur_isi    = 1.000;
P.timing.dur_target = 1.000;
P.timing.dur_delay  = 0.800;


%% ------------------------------------------------------------------------
%  Test colors
%  ------------------------------------------------------------------------
% lab color space parameters

% Brady 2016.
% P.colors.lightness = 54;
% P.colors.a         = 18;
% P.colors.b         = -8;
% P.colors.radius    = 59;

% Zhang & Luck 2008.
P.colors.lightness = 70;
P.colors.a         = 20;
P.colors.b         = 38;
P.colors.radius    = 60;
% P.colors.degreeSeparation = 15;


%% ------------------------------------------------------------------------
%  Parameters of the display geometry.
%  ------------------------------------------------------------------------
P.display.bg = P.screen.black;%(P.screen.white + P.screen.black) ./2;
P.display.item_diam = 2;
P.display.item_ecce = 4;
P.display.fix_size = 0.5;
P.display.fix_color = (P.screen.white + P.screen.black) ./4;



%% ------------------------------------------------------------------------
%  Define relevant buttons
%  ------------------------------------------------------------------------
KbName('UnifyKeyNames');
P.keys.upkey = KbName('UpArrow');
P.keys.downkey = KbName('DownArrow');
P.keys.quitkey = KbName('ESCAPE');
P.keys.proceedkey = KbName('UpArrow');
P.keys.proceedkeyname = '''nach Oben''';
P.pad.y = 4;
P.pad.a = 2;
P.pad.dpadUp = 0;
P.pad.dpadDown = 180;
P.pad.dpadNull = -1;


%% Done.

