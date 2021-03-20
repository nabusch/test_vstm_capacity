%-------------------------------------------------------------------------
% 2AFC Change Detection with Colors and Objects
%
% Programmed by Colin Quirk - Last updated Aug. 27, 2016
%
% Any questions can be directed to cquirk@uchicago.edu
%
% This design is a replication of experiment 1 in Brady, Störmer, and
% Alvarez (2016) with some adjustments. All code is my own.
% 
% To run this code, you must have a folder of objects with subfolders for
% each catagory of item. I used a renamed and resized version of Tim
% Brady's object set from Brady, Alvarez, and Oliva (2010) avaliable at
% timbrady.org/stimuli.html
% 
% This code is designed to run on a PC. If you wish to run it on a mac,
% change the delete key to 'delete' and switch the direction of the slash
% when generating the image paths. You may also need to set
% expPreferences.skipSyncTests = 1 depending on the screen you are using.
% 
% Be sure to edit the preferences before attempting to run the code.
% 
% Data is output as a .mat file which stores the trialInfo, expPreferences,
% and window structures. During the experiment, a temporary .mat file is
% created after every block or if the experiment is quit early. At the end 
% of the experiment, two .mat files are created, one containing all of the 
% fields (_all) and one containing only the ones that are likely needed for
% data analysis (_clean). The temporary .mat files are then deleted.
%
% Escape will quit the experiment if pressed while the program is looking
% for a response. I got rid of the confirmation screen because it doesn't
% work in windows 7 so be careful.
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% MIT License
% 
% Copyright (c) 2016 Colin Quirk
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% Set Preferences
%-------------------------------------------------------------------------
expPreferences.numBlocks = 6; %must be divisible by number of conditions
expPreferences.numConditions = 6;
expPreferences.numTrialsTotal = 30; %must be divisible by number of blocks
expPreferences.setSize = 6;
expPreferences.numNumbers = 2; %must be divisible by 2

expPreferences.design = 'blocked'; %mixed or blocked

% Must be edited for your personal computer
expPreferences.objectsFilepath = '/Users/Colin/Desktop/Brady/Experiment1/Documents/BradyObjects/';

% in milliseconds
expPreferences.numDuration = 2000;
expPreferences.fixDuration = 1000;
expPreferences.stimDuration = [200,1000,2000]; 
expPreferences.memDuration = 800;
expPreferences.cueDuration = 500;
expPreferences.itiDuration = 500;

% lab color space parameters
expPreferences.lightness = 54;
expPreferences.a = 18;
expPreferences.b = -8;
expPreferences.radius = 59;
expPreferences.degreeSeparation = 15;
            
expPreferences.stimSize = 100;
expPreferences.fixSize = 12;
expPreferences.holderSize = 24;
expPreferences.cueSize = 48;
expPreferences.pixelsFromFixation = 200;

expPreferences.keys.topKey = 'uparrow';
expPreferences.keys.botKey = 'downarrow';

expPreferences.backgroundColor = 'white'; %white, grey, or black
expPreferences.numTextSize = 60;
expPreferences.instructTextSize = 22;
expPreferences.otherTextSize = 30;
expPreferences.textFont = 'Arial';
expPreferences.textColor = [0 0 0];
expPreferences.holderColor = [128 128 128];
expPreferences.numberColor = [0 0 0];

expPreferences.instructText = strcat('This experiment is going to test your memory.\n\n\n',...
    'On each trial you will be given 2 digits to repeat in your head.\n\n',...
    'Then, you will be given 6 items to remember.\n\n\n',...
    'After a short delay, there will be a flash indicating which location the item you will be tested on appeared.\n\n',...
    'Two items will then appear above and below that location.\n\n',...
    'If you think the top item was the one you saw, press the up arrow key.\n\n',...
    'If you think the bottom item was the one you saw, press the down arrow key.\n\n\n',...
    'Finally, you will be asked to enter the digits you have been repeating.\n\n',...
    'To do this, use the number pad. If you make a mistake, press backspace to begin again.\n\n',...
    'Keep your eyes on the dot in the center of the screen whenever it is there.\n\n',...
    'You will get breaks at multiple points throughout the experiment.\n\n',...
    'If you have any questions or you have completed the experiment, please find your experimenter.\n\n\n',...
    'Press space to begin the experiment...');

% Debugging options
% While running participants saveData must be 1 and skipSyncTests must be 0
expPreferences.saveData = 0;
expPreferences.skipSyncTests = 1;
%-------------------------------------------------------------------------
% Ensure preferences are set correctly
%-------------------------------------------------------------------------
assert(mod(expPreferences.numTrialsTotal,expPreferences.numBlocks) == 0,...
    'The number of trials must be divisible by the number of blocks.')

assert(mod(expPreferences.numBlocks,expPreferences.numConditions)==0,...
    'Number of blocks must be divisable by the number of conditions.')

assert(mod(expPreferences.numNumbers,2) == 0,...
    'The number of digits to be remembered must be divisible by two.')

assert(strcmp(expPreferences.design,'mixed') || strcmp(expPreferences.design,'blocked'),...
    'Design must be set to mixed or blocked.')
%-------------------------------------------------------------------------
% Ask for Subject Info
%-------------------------------------------------------------------------
subjectInfo = inputdlg({'Subject Number'},'Enter Subject Info',1,{''});
if ~isempty(subjectInfo) && ~isempty(subjectInfo{1})
    expPreferences.subNum = subjectInfo{1};
else
    return;
end
%-------------------------------------------------------------------------
% Set up the enivorniment and fix values
%-------------------------------------------------------------------------
ListenChar(2)

trialInfo.randseed = rng('shuffle');

expPreferences.trialsPerBlock = expPreferences.numTrialsTotal/expPreferences.numBlocks;
expPreferences.trialsPerCond = expPreferences.numTrialsTotal/expPreferences.numConditions;

expPreferences.numDuration = expPreferences.numDuration / 1000;
expPreferences.fixDuration = expPreferences.fixDuration / 1000;
expPreferences.stimDuration = expPreferences.stimDuration / 1000;
expPreferences.memDuration = expPreferences.memDuration / 1000;
expPreferences.cueDuration = expPreferences.cueDuration / 1000;
expPreferences.itiDuration = expPreferences.itiDuration / 1000;

KbName('UnifyKeyNames');

expPreferences.keys.escape = KbName('ESCAPE');
expPreferences.keys.space = KbName('space');
expPreferences.keys.delete = KbName('delete'); %delete if on mac
expPreferences.keys.topKey = KbName(expPreferences.keys.topKey); 
expPreferences.keys.botKey = KbName(expPreferences.keys.botKey);

expPreferences.keys.nums.one = KbName('1');
expPreferences.keys.nums.two = KbName('2');
expPreferences.keys.nums.three = KbName('3');
expPreferences.keys.nums.four = KbName('4');
expPreferences.keys.nums.five = KbName('5');
expPreferences.keys.nums.six = KbName('6');
expPreferences.keys.nums.seven = KbName('7');
expPreferences.keys.nums.eight = KbName('8');
expPreferences.keys.nums.nine = KbName('9');

expPreferences.keys.stimRespAcceptKeys = [expPreferences.keys.escape, expPreferences.keys.space, expPreferences.keys.topKey, expPreferences.keys.botKey];
expPreferences.keys.numRespAcceptKeys = [expPreferences.keys.escape, expPreferences.keys.space, expPreferences.keys.delete, expPreferences.keys.nums.one, expPreferences.keys.nums.two, expPreferences.keys.nums.three,...
    expPreferences.keys.nums.four, expPreferences.keys.nums.five, expPreferences.keys.nums.six, expPreferences.keys.nums.seven, expPreferences.keys.nums.eight, expPreferences.keys.nums.nine];

if expPreferences.skipSyncTests
    Screen('Preference', 'SkipSyncTests', 1);
end
%-------------------------------------------------------------------------
% Get window information and set colors based on screen
%-------------------------------------------------------------------------
window.number = max(Screen('Screens'));
[window.pointer, window.rect] = Screen('OpenWindow', window.number, [128 128 128],[],[],[],[]);
[window.xLength, window.yLength] = Screen('WindowSize', window.pointer);    
[window.xCenter, window.yCenter] = RectCenter(window.rect);

window.colors.black = BlackIndex(window.pointer);
window.colors.white = WhiteIndex(window.pointer);
window.colors.grey  = mean([window.colors.black window.colors.white]);

expPreferences.backgroundColor = lower(expPreferences.backgroundColor);
expPreferences.holderColor = lower(expPreferences.holderColor);

switch expPreferences.backgroundColor
    case 'white'
        expPreferences.backgroundColor = window.colors.white;
    case 'black'
        expPreferences.backgroundColor = window.colors.black;
    case {'grey','gray'}
        expPreferences.backgroundColor = window.colors.grey;
end
%-------------------------------------------------------------------------
% Display Loading Screen
%-------------------------------------------------------------------------
HideCursor();

Screen('TextFont',window.pointer,expPreferences.textFont);
Screen('TextSize',window.pointer,expPreferences.otherTextSize);

Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
DrawFormattedText(window.pointer, 'Loading...', 'center','center', expPreferences.textColor);
Screen('Flip',window.pointer);
%-------------------------------------------------------------------------
% Set nonrandom trial information
%-------------------------------------------------------------------------
trialInfo.baseFixRect = [0, 0, expPreferences.fixSize, expPreferences.fixSize];
trialInfo.baseStimRect = [0, 0, expPreferences.stimSize, expPreferences.stimSize];
trialInfo.baseHolderRect = [0, 0, expPreferences.holderSize, expPreferences.holderSize];
trialInfo.baseCueRect = [0, 0, expPreferences.cueSize, expPreferences.cueSize];
trialInfo.fixRect = CenterRectOnPoint(trialInfo.baseFixRect, window.xCenter, window.yCenter);

% Initialize Arrarys
trialInfo.angles = NaN(1,expPreferences.setSize);
trialInfo.stimCenters = cell(1,expPreferences.setSize);
trialInfo.stimRects = NaN(4,expPreferences.setSize);
trialInfo.holderRects = NaN(4,expPreferences.setSize);
trialInfo.colors = NaN(3,360);
trialInfo.labCirclePoints = NaN(2,360);

for i = 1:expPreferences.setSize
    trialInfo.angles(i) = (((2*pi)/expPreferences.setSize)*i) - (2*pi/3); % subtracting 2*pi/3 places first object in top right for set size 6
    trialInfo.stimCenters{i} = [round(expPreferences.pixelsFromFixation*cos(trialInfo.angles(i)) + window.xCenter),...
        round(expPreferences.pixelsFromFixation*sin(trialInfo.angles(i)) + window.yCenter)];
    trialInfo.stimRects(:,i) = CenterRectOnPoint(trialInfo.baseStimRect, trialInfo.stimCenters{i}(1), trialInfo.stimCenters{i}(2))';
    trialInfo.holderRects(:,i) = CenterRectOnPoint(trialInfo.baseHolderRect, trialInfo.stimCenters{i}(1), trialInfo.stimCenters{i}(2))';
end

for i = 1:360
   x = round(expPreferences.a + expPreferences.radius * sind(i));
   y = round(expPreferences.b + expPreferences.radius * cosd(i));
   trialInfo.labCirclePoints(:,i) = [x;y];
   trialInfo.colors(:,i) = lab2rgb([expPreferences.lightness, x, y],'OutputType','uint8');
end

% This may need to be adjusted depending on the files present in your objects folder
trialInfo.objectFolders = dir(expPreferences.objectsFilepath);
trialInfo.objectFolders = trialInfo.objectFolders([trialInfo.objectFolders.isdir]);
trialInfo.objectFolders = trialInfo.objectFolders(~ismember({trialInfo.objectFolders.name},{'.','..'}));
trialInfo.objectFolders = struct2cell(trialInfo.objectFolders);
trialInfo.objectFolders = trialInfo.objectFolders(1,:);
%-------------------------------------------------------------------------
% Initialize values/arrays
%-------------------------------------------------------------------------
trialInfo.testLocations = randi(expPreferences.setSize,expPreferences.numConditions,expPreferences.trialsPerCond);

[trialInfo.datetime, trialInfo.stimDuration, trialInfo.trialType, trialInfo.memNumbers, trialInfo.numStrings, trialInfo.numRESP, trialInfo.stimColors, trialInfo.cueRects, trialInfo.testRects, trialInfo.testColors,...
    trialInfo.VBLStamps, trialInfo.stimOnsets, trialInfo.flipStamps, trialInfo.flipMisses, trialInfo.stimObjects, trialInfo.objectCatagories] = deal(cell(expPreferences.numConditions,expPreferences.trialsPerCond));

[trialInfo.CRESP, trialInfo.colorCRESP, trialInfo.objectCRESP, trialInfo.RESP, trialInfo.ACC, trialInfo.RT, trialInfo.numACC] = deal(NaN(expPreferences.numConditions,expPreferences.trialsPerCond));

trialInfo.imageTextures = cell(200,15);

perSide = expPreferences.numNumbers/2;
%-------------------------------------------------------------------------
% Load images into textures
%-------------------------------------------------------------------------
for i = 1:numel(trialInfo.objectFolders)
    folder = trialInfo.objectFolders{i};
    trialInfo.imageFilepaths = dir(strcat(expPreferences.objectsFilepath,folder,'/',folder,'*.jpg')); %switch slash when on OS X
    trialInfo.imageFilepaths = struct2cell(trialInfo.imageFilepaths);
    trialInfo.imageFilepaths = trialInfo.imageFilepaths(1,:);
    trialInfo.imageFilepaths = strcat(expPreferences.objectsFilepath,folder,'/',trialInfo.imageFilepaths); %switch slash when on OS X
    
    for j = 1:numel(trialInfo.imageFilepaths)
        loadedImage = imread(trialInfo.imageFilepaths{j});
        trialInfo.imageTextures{i,j} = Screen('MakeTexture', window.pointer, loadedImage);
    end
end
%-------------------------------------------------------------------------
% Build trials
%-------------------------------------------------------------------------

% for simplicity a full array of colors and objects is created and
% which set to display is determined based on the trial type

for i = 1:expPreferences.numConditions
    for j = 1:expPreferences.trialsPerCond
        
        % generate digits to be remembered, if number of digits is > 2 then
        % set the 1st digits > 1 to avoid years, 1234, etc.
        if expPreferences.numNumbers < 3
            trialInfo.memNumbers{i,j} = randperm(9,expPreferences.numNumbers);
        else
            trialInfo.memNumbers{i,j} = [randi([1,8])+1,randperm(9,expPreferences.numNumbers-1)];
        end
        
        % make the digits into a string to be displayed
        % simpliest to just add white space and display all of them at once
        % this is why the number of digits must be divisible by 2
        for k = 1:expPreferences.numNumbers
            trialInfo.numStrings{i,j} = [trialInfo.numStrings{i,j},num2str(trialInfo.memNumbers{i,j}(k))];
            if k == expPreferences.numNumbers
                %pass
            elseif k == perSide
                trialInfo.numStrings{i,j} = [trialInfo.numStrings{i,j},'        '];
            else
                trialInfo.numStrings{i,j} = [trialInfo.numStrings{i,j},'    '];
            end
        end
        
        trialInfo.cueRects{i,j} = CenterRectOnPoint(trialInfo.baseCueRect, trialInfo.stimCenters{trialInfo.testLocations(i,j)}(1),...
            trialInfo.stimCenters{trialInfo.testLocations(i,j)}(2))';
        
        % creates two rects centered at 60% above and below the test loc.
        % math could be simplified, but this makes the buffer space easier to adjust/think about individually
        trialInfo.testRects{i,j} = [CenterRectOnPoint(trialInfo.baseStimRect, trialInfo.stimCenters{trialInfo.testLocations(i,j)}(1),...
            (trialInfo.stimCenters{trialInfo.testLocations(i,j)}(2)-((expPreferences.stimSize/2)+round(expPreferences.stimSize*.1))))',...
            CenterRectOnPoint(trialInfo.baseStimRect, trialInfo.stimCenters{trialInfo.testLocations(i,j)}(1),...
            (trialInfo.stimCenters{trialInfo.testLocations(i,j)}(2)+((expPreferences.stimSize/2)+round(expPreferences.stimSize*.1))))'];
        
        trialInfo.stimColorsIndex{i,j} = NaN(1,expPreferences.setSize);
        
        % choose the test color 
        trialInfo.stimColorsIndex{i,j}(trialInfo.testLocations(i,j)) = randi([1 360]);

        % determine the foil color
        if trialInfo.stimColorsIndex{i,j}(trialInfo.testLocations(i,j)) > 180
            foilColorIndex = trialInfo.stimColorsIndex{i,j}(trialInfo.testLocations(i,j)) - 180;
        else
            foilColorIndex = trialInfo.stimColorsIndex{i,j}(trialInfo.testLocations(i,j)) + 180;
        end
        
        trialInfo.testColors{i,j} = [trialInfo.colors(:,trialInfo.stimColorsIndex{i,j}(trialInfo.testLocations(i,j))), trialInfo.colors(:,foilColorIndex)];
        
        % keep a record of what colors can no longer be selected. Could be
        % switched to a bool matrix, but this is easier to look at while debugging
        badColorIndexes = [];
        badColorIndexes = trialInfo.stimColorsIndex{i,j}(trialInfo.testLocations(i,j))-expPreferences.degreeSeparation:trialInfo.stimColorsIndex{i,j}(trialInfo.testLocations(i,j))+expPreferences.degreeSeparation;
        badColorIndexes = horzcat(badColorIndexes,foilColorIndex-expPreferences.degreeSeparation:foilColorIndex+expPreferences.degreeSeparation);
        
        badColorIndexes = horzcat(badColorIndexes(badColorIndexes<=360),badColorIndexes(badColorIndexes>360)-360);
        badColorIndexes = horzcat(badColorIndexes(badColorIndexes>=1),badColorIndexes(badColorIndexes<1)+360);
        badColorIndexes = unique(badColorIndexes);
        
        trialInfo.stimColors{i,j} = NaN(3,expPreferences.setSize);
        
        % generate the stim colors and place the test color
        for k = 1:expPreferences.setSize
            if k == trialInfo.testLocations(i,j)
                trialInfo.stimColors{i,j}(:,k) = trialInfo.testColors{i,j}(:,1);
                continue
            end
            
            options = setdiff(1:360,badColorIndexes);
            trialInfo.stimColorsIndex{i,j}(k) = options(randperm(numel(options),1));

            badColorIndexes = horzcat(badColorIndexes,trialInfo.stimColorsIndex{i,j}(k)-expPreferences.degreeSeparation:trialInfo.stimColorsIndex{i,j}(k)+expPreferences.degreeSeparation);
            badColorIndexes = horzcat(badColorIndexes(badColorIndexes<=360),badColorIndexes(badColorIndexes>360)-360);
            badColorIndexes = horzcat(badColorIndexes(badColorIndexes>=1),badColorIndexes(badColorIndexes<1)+360);
            badColorIndexes = unique(badColorIndexes);
            
            trialInfo.stimColors{i,j}(:,k) = trialInfo.colors(:,trialInfo.stimColorsIndex{i,j}(k));
        end
        
        % randomize test/foil color locations and set correct response
        tempItems = trialInfo.testColors{i,j};
        trialInfo.testColors{i,j} = trialInfo.testColors{i,j}(:,randperm(size(trialInfo.testColors{i,j},2)));
        if tempItems == trialInfo.testColors{i,j}
            trialInfo.colorCRESP(i,j) = expPreferences.keys.topKey;
        else
            trialInfo.colorCRESP(i,j) = expPreferences.keys.botKey;
        end
        
        % select random object catagories and add an extra at the end to be the foil object
        trialInfo.objectCatagories{i,j} = randperm(length(trialInfo.imageTextures),expPreferences.setSize+1);

        % choose the specific object within the catagory and save it
        for k = 1:numel(trialInfo.objectCatagories{i,j})
           trialInfo.stimObjectsIndex{i,j}(k,:) = [trialInfo.objectCatagories{i,j}(k),randi(15)];
           trialInfo.stimObjects{i,j}(k) = trialInfo.imageTextures(trialInfo.stimObjectsIndex{i,j}(k,1),trialInfo.stimObjectsIndex{i,j}(k,2));
        end
        
        % save the test objects
        trialInfo.testObjects{i,j} = [trialInfo.imageTextures{trialInfo.stimObjectsIndex{i,j}(trialInfo.testLocations(i,j),1),...
            trialInfo.stimObjectsIndex{i,j}(trialInfo.testLocations(i,j),2)},...
            trialInfo.imageTextures{trialInfo.stimObjectsIndex{i,j}(end,1), trialInfo.stimObjectsIndex{i,j}(end,2)}];
            
        % randomize locations of test objects and set correct response
        tempItems = trialInfo.testObjects{i,j};
        trialInfo.testObjects{i,j} = trialInfo.testObjects{i,j}(:,randperm(size(trialInfo.testObjects{i,j},2)));
        if tempItems == trialInfo.testObjects{i,j}
            trialInfo.objectCRESP(i,j) = expPreferences.keys.topKey;
        else
            trialInfo.objectCRESP(i,j) = expPreferences.keys.botKey;
        end
        
    end
end
%-------------------------------------------------------------------------
% Build blocks
%-------------------------------------------------------------------------
% learned about fullFact too late
trialInfo.blocks = cell(1,numel(expPreferences.stimDuration)*2);
for i = 1:numel(expPreferences.stimDuration)
    trialInfo.blocks{i} = {'color',expPreferences.stimDuration(i)};
    trialInfo.blocks{i+numel(expPreferences.stimDuration)} = {'object',expPreferences.stimDuration(i)};
end

trialInfo.blocks = trialInfo.blocks(randperm(size(trialInfo.blocks,2)));

for i = 1:expPreferences.numConditions
    for j = 1:expPreferences.trialsPerCond
        trialInfo.trialType{i,j} = trialInfo.blocks{i}{1};
        trialInfo.stimDuration{i,j} = trialInfo.blocks{i}{2};
    end
end

% if mixed, mix it up
if strcmp(expPreferences.design,'mixed')
    trialInfo.stimDuration = reshape(trialInfo.stimDuration(randperm(numel(trialInfo.stimDuration))),expPreferences.numConditions,expPreferences.trialsPerCond);
    trialInfo.trialType = reshape(trialInfo.trialType(randperm(numel(trialInfo.trialType))),expPreferences.numConditions,expPreferences.trialsPerCond);
end
%-------------------------------------------------------------------------
% Display Instructions
%-------------------------------------------------------------------------
Screen('FillRect', window.pointer, expPreferences.backgroundColor, window.rect);
DrawFormattedText(window.pointer, 'Welcome to the experiment! Press space to begin','center','center',expPreferences.textColor);
Screen('Flip', window.pointer);

KbStrokeWait;

Screen('FillRect',window.pointer, expPreferences.backgroundColor, window.rect);
DrawFormattedText(window.pointer, expPreferences.instructText,'center','center',expPreferences.textColor);
Screen('Flip',window.pointer);

KbStrokeWait;
%-------------------------------------------------------------------------
% Display Experiment
%-------------------------------------------------------------------------
for i = 1:expPreferences.numConditions
    for j = 1:expPreferences.trialsPerCond
        
        trialInfo.datetime{i,j} = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss:SSS'); 
        
        Screen('TextSize',window.pointer,expPreferences.numTextSize);
        
        tempVBLStamps = [];
        tempStimOnsets = [];
        tempFlipStamps = [];
        tempFlipMisses = [];
        
        % DrawingFinished seems to reduce flip misses even if it comes right before the flip
        
        % display numbers
        Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
        Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
        DrawFormattedText(window.pointer,trialInfo.numStrings{i,j},'center','center',expPreferences.numberColor);
        Screen('DrawingFinished', window.pointer);
        [tempVBLStamps(end+1), tempStimOnsets(end+1), tempFlipStamps(end+1), tempFlipMisses(end+1), ~] = Screen('Flip',window.pointer);
%         imwrite(Screen('GetImage', window.pointer),'~/Desktop/nums.png','PNG')
        WaitSecs(expPreferences.numDuration);
        
        % display fixation/placeholders
        Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
        Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
        Screen('FillOval',window.pointer,expPreferences.holderColor,trialInfo.holderRects);
        Screen('DrawingFinished', window.pointer);
        [tempVBLStamps(end+1), tempStimOnsets(end+1), tempFlipStamps(end+1), tempFlipMisses(end+1), ~] = Screen('Flip',window.pointer);
%         imwrite(Screen('GetImage', window.pointer),'~/Desktop/placeholders.png','PNG')
        WaitSecs(expPreferences.fixDuration);
        
        % display colors or objects based on trial type
        Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
        Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
        
        if strcmp(trialInfo.trialType{i,j},'color')
            Screen('FillRect',window.pointer,trialInfo.stimColors{i,j}(:,1:expPreferences.setSize),trialInfo.stimRects);
        else
            Screen('DrawTextures',window.pointer,[trialInfo.stimObjects{i,j}{1:expPreferences.setSize}],[],trialInfo.stimRects);           
        end
        
        Screen('DrawingFinished', window.pointer);
        [tempVBLStamps(end+1), tempStimOnsets(end+1), tempFlipStamps(end+1), tempFlipMisses(end+1), ~] = Screen('Flip',window.pointer);
        if strcmp(trialInfo.trialType{i,j},'color')
%             imwrite(Screen('GetImage', window.pointer),'~/Desktop/colors.png','PNG')
        else
%             imwrite(Screen('GetImage', window.pointer),'~/Desktop/objects.png','PNG')
        end
        WaitSecs(trialInfo.stimDuration{i,j});
            
        % display fixation/placeholders during retention
        Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
        Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
        Screen('FillOval',window.pointer,expPreferences.holderColor,trialInfo.holderRects);
        Screen('DrawingFinished', window.pointer);
        [tempVBLStamps(end+1), tempStimOnsets(end+1), tempFlipStamps(end+1), tempFlipMisses(end+1), ~] = Screen('Flip',window.pointer);
        WaitSecs(expPreferences.memDuration);
        
        % display cue
        Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
        Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
        Screen('FillOval',window.pointer,expPreferences.holderColor,trialInfo.holderRects);
        Screen('FillOval',window.pointer,expPreferences.holderColor,trialInfo.cueRects{i,j});
        Screen('DrawingFinished', window.pointer);
        [tempVBLStamps(end+1), tempStimOnsets(end+1), tempFlipStamps(end+1), tempFlipMisses(end+1), ~] = Screen('Flip',window.pointer);
%         imwrite(Screen('GetImage', window.pointer),'~/Desktop/cue.png','PNG')
        WaitSecs(expPreferences.cueDuration);
        
        % display test
        Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
        Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
        
        if strcmp(trialInfo.trialType{i,j},'color')
            Screen('FillRect',window.pointer,trialInfo.testColors{i,j},trialInfo.testRects{i,j});
        else
            Screen('DrawTextures',window.pointer,[trialInfo.testObjects{i,j}],[],trialInfo.testRects{i,j});
        end
        
        Screen('DrawingFinished', window.pointer);
        [tempVBLStamps(end+1), tempStimOnsets(end+1), tempFlipStamps(end+1), tempFlipMisses(end+1), ~] = Screen('Flip',window.pointer);
       
        if strcmp(trialInfo.trialType{i,j},'color')
%             imwrite(Screen('GetImage', window.pointer),'~/Desktop/color_test.png','PNG')
        else
%             imwrite(Screen('GetImage', window.pointer),'~/Desktop/object_test.png','PNG')
        end
        
        % wait for response/save data
        while 1
            rtStart = GetSecs; 
            [rtEnd,keyCode,delta] = KbPressWait;
            keyPressed = find(keyCode);
            
            if numel(keyPressed) > 1
                continue
            end
            
            if any(keyPressed == expPreferences.keys.stimRespAcceptKeys)
                if keyPressed == expPreferences.keys.escape
                    if expPreferences.saveData
                        save(strcat(expPreferences.subNum,'_quit'),'expPreferences','window','trialInfo');
                    end
                    ListenChar(0)
                    Screen('Close')
                    sca;   
                    return
                else
                    % if they aren't quitting, store the data
                    trialInfo.lastKbCheck(i,j) = round(delta * 1000); %milliseconds
                    trialInfo.RESP(i,j) = keyPressed;

                    if strcmp(trialInfo.trialType{i,j},'color')
                        trialInfo.CRESP(i,j) = trialInfo.colorCRESP(i,j);
                    else
                        trialInfo.CRESP(i,j) = trialInfo.objectCRESP(i,j);
                    end
                        
                    if keyPressed == trialInfo.CRESP(i,j)
                        trialInfo.ACC(i,j) = 1;
                    else
                        trialInfo.ACC(i,j) = 0;
                    end

                    trialInfo.RT(i,j) = (rtEnd - rtStart) * 1000;
                    break
                end
            end
        end
        
        % display number recall
        if expPreferences.numNumbers > 0
            Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
            Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
            Screen('TextSize',window.pointer,expPreferences.otherTextSize);
            DrawFormattedText(window.pointer,...
                'Enter the numbers from the beginning of the trial.\n\nPress backspace to start over.\n\nPress space when you are done.',...
                'center', window.yLength * 0.66, expPreferences.numberColor);
            Screen('TextSize',window.pointer,expPreferences.numTextSize);
            Screen('DrawingFinished', window.pointer);
            [tempVBLStamps(end+1), tempStimOnsets(end+1), tempFlipStamps(end+1), tempFlipMisses(end+1), ~] = Screen('Flip',window.pointer);

            numDispString = '';
            numsDisplayed = 0;

            while 1
                [~,keyCode,~] = KbPressWait;
                keyPressed = find(keyCode);

                if numel(keyPressed) > 1
                    continue
                end

                if any(keyPressed == expPreferences.keys.numRespAcceptKeys)
                    switch keyPressed
                        case {expPreferences.keys.escape}
                            if expPreferences.saveData
                                save(strcat(expPreferences.subNum,'_quit'),'expPreferences','window','trialInfo');
                            end
                            ListenChar(0)
                            Screen('Close')
                            sca;   
                            return
                        case {expPreferences.keys.delete}
                            numDispString = '';
                            numsDisplayed = 0;

                            Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
                            Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
                            Screen('TextSize',window.pointer,expPreferences.otherTextSize);
                            DrawFormattedText(window.pointer,...
                                'Enter the numbers from the beginning of the trial.\n\nPress backspace to start over.\n\nPress space when you are done.',...
                                'center', window.yLength * 0.66, expPreferences.numberColor);
                            Screen('TextSize',window.pointer,expPreferences.numTextSize);
                            Screen('DrawingFinished', window.pointer);
                            Screen('Flip',window.pointer);

                            continue
                        case {expPreferences.keys.space}
                            if numsDisplayed < expPreferences.numNumbers
                                continue
                            else
                                numDispString = numDispString(numDispString~=' ');
                                for k = 1:expPreferences.numNumbers
                                    trialInfo.numRESP{i,j} = [trialInfo.numRESP{i,j}, str2double(numDispString(k))];
                                end

                                if isequal(trialInfo.numRESP{i,j},trialInfo.memNumbers{i,j})
                                    trialInfo.numACC(i,j) = 1;
                                else
                                    trialInfo.numACC(i,j) = 0;
                                end

                                break
                            end
                        case {expPreferences.keys.nums.one, expPreferences.keys.nums.two, expPreferences.keys.nums.three, expPreferences.keys.nums.four, expPreferences.keys.nums.five,...
                                expPreferences.keys.nums.six, expPreferences.keys.nums.seven, expPreferences.keys.nums.eight, expPreferences.keys.nums.nine}

                            numPressed = KbName(keyPressed);

                            if numsDisplayed == expPreferences.numNumbers
                                continue
                            elseif numsDisplayed == expPreferences.numNumbers - 1 && numsDisplayed > 0
                                numDispString = [numDispString,numPressed];
                            else
                                numDispString = [numDispString,numPressed,'    '];
                            end

                            numsDisplayed = numsDisplayed + 1;

                            Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
                            Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
                            Screen('TextSize',window.pointer,expPreferences.otherTextSize);
                            DrawFormattedText(window.pointer,...
                                'Enter the numbers from the beginning of the trial.\n\nPress backspace to start over.\n\nPress space when you are done.',...
                                'center', window.yLength * 0.66, expPreferences.numberColor);
                            Screen('TextSize',window.pointer,expPreferences.numTextSize);
                            DrawFormattedText(window.pointer, numDispString,'center', window.yLength * 0.40, expPreferences.numberColor);
                            Screen('DrawingFinished', window.pointer);
                            Screen('Flip',window.pointer);
                    end
                end
            end
        end
        
        trialInfo.VBLStamps{i,j} = tempVBLStamps;
        trialInfo.stimOnsets{i,j} = tempStimOnsets;
        trialInfo.flipStamps{i,j} = tempFlipStamps;
        trialInfo.flipMisses{i,j} = tempFlipMisses;
        
        % break
        if mod(j,expPreferences.trialsPerBlock) == 0 && i*j ~= expPreferences.numTrialsTotal 
            Screen('TextSize',window.pointer,expPreferences.otherTextSize);

            Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
            Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
            DrawFormattedText(window.pointer, 'Take a break.  Press space to continue.', 'center',...
                round(window.yLength * 0.38), expPreferences.textColor);
            Screen('DrawingFinished', window.pointer);
            Screen('Flip',window.pointer);

            if expPreferences.saveData
                save(strcat(expPreferences.subNum,'_block',num2str(i)),'expPreferences','window','trialInfo');
            end

            KbStrokeWait;
        end
        
        % short ITI
        Screen('FillRect',window.pointer,expPreferences.backgroundColor,window.rect);
        Screen('FillOval',window.pointer,window.colors.black,trialInfo.fixRect);
        Screen('DrawingFinished', window.pointer);
        Screen('Flip',window.pointer);
        WaitSecs(expPreferences.itiDuration);
    end
end

% End Experiment Screen
Screen('TextSize',window.pointer,expPreferences.otherTextSize);
Screen('FillRect',window.pointer,[0 0 255],window.rect);
DrawFormattedText(window.pointer,...
    'That''s the end of the experiment! Thank you for participating.\n\nPlease find your experimenter.',...
    'center','center', [255 255 255]);
Screen('Flip',window.pointer);
KbStrokeWait;

% Save the data and delete the temp files
if expPreferences.saveData
    save(strcat(expPreferences.subNum,'_all'),'expPreferences','window','trialInfo');
    trialInfo = rmfield(trialInfo,{'baseFixRect','baseStimRect','baseHolderRect','baseCueRect','fixRect','angles'...
                       'randseed','stimCenters','stimRects','holderRects','colors','labCirclePoints','objectFolders'...
                       'testLocations','numStrings','cueRects','testRects','colorCRESP','imageTextures','imageFilepaths'...
                       'stimColorsIndex','objectCatagories','blocks'});
    save(strcat(expPreferences.subNum,'_clean'),'expPreferences','window','trialInfo');
    for i = 1:expPreferences.numConditions-1
        delete(strcat(expPreferences.subNum,'_block',num2str(i),'.mat'))
    end
end

%-------------------------------------------------------------------------
% Clean Up
%-------------------------------------------------------------------------
ListenChar(0)
clear ans badColorIndexes options delta foilColorIndex folder i j k keyCode keyPressed loadedImage numDispString numPressed numsDisplayed ...
    perSide ptb_ConfigPath ptb_RootPath rtEnd rtStart subjectInfo tempItems tempFlipMisses tempFlipStamps tempStimOnsets...
    tempVBLStamps x y
Screen('Close') %PTB gives an 'all textures are open' warning if only sca; is used...
sca;     