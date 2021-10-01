function runSPEAKboardgame(ExptParamsPath)
rng('shuffle');
%% Window to get subject info
prompt = {'Subject ID:'};
boxtitle = 'Subject Information';
dims = [1 35];
definput = {'CM000'};
answer = inputdlg(prompt,boxtitle,dims,definput, 'on');

%% Create folder to save subject data
SubjectName = answer{1};

ConfigFileInfo = strsplit(ExptParamsPath, '\');
ConfigFileName = char(ConfigFileInfo(end));
ConfigName = ConfigFileName(1:end-4);

%%% Need to get the SPEA-K folder
SPEAKpath = which('SPEAK.mlapp');
SPEAKFolder = SPEAKpath(1:end-11);
SPEAKSourceFolder = fullfile(SPEAKpath(1:end-12), 'SPEAK-source\');

addpath(fullfile(SPEAKSourceFolder));

SubjectFolder = fullfile(SPEAKFolder, 'Data', ConfigName, SubjectName);
if ~exist(SubjectFolder, 'dir')
    SubjectDataFolder = fullfile(SubjectFolder, '1');
    mkdir(SubjectDataFolder);
else
    SubjectDataFolderList = dir(SubjectFolder);
    SubjectDataFolderList(strcmp({SubjectDataFolderList.name}, '.'))=[]; %remove folder '.'
    SubjectDataFolderList(strcmp({SubjectDataFolderList.name}, '..'))=[]; % remove folder '..'
    SubjectDataFolder = fullfile(SubjectFolder, num2str(length(SubjectDataFolderList)+1));
    mkdir(SubjectDataFolder)
end

%% Add path to helper functions
% Visualization and gameplay helper functions
% Audapter helper functions
mcode_path = 'C:\speechres\audapter_matlab\mcode';
commonmcode_path = 'C:\speechres\commonmcode';
audapter_path = 'C:\speechres\audapter\Audapter-2.1\BIN\Release';

if ~(exist(mcode_path) && exist(commonmcode_path) && exist(audapter_path))
    errordlg('Audapter not found under the correct path!');
    error('Audapter not found under the correct path!');
end

addpath(mcode_path); 
addpath(commonmcode_path);
addpath(audapter_path);
%% Load config MAT file, gameData.mat, and change fields based on config
load(ExptParamsPath, 'ConfigParams');
load('gameData.mat', 'gd');

gd.wordPath = ConfigParams.Game.PicPath;
gd.imPath = ConfigParams.Game.PicPath;


gd.picPath = fullfile(SPEAKFolder, 'GameImages\GameBoardImages\');
gd.path.star = fullfile(gd.picPath, 'star.jpg');
gd.path.target = fullfile(gd.picPath, 'target.jpg');
gd.path.tracks{1,1} = fullfile(gd.picPath, 'tracks1.jpg');
gd.path.tracks{1,2} = fullfile(gd.picPath, 'tracks2.jpg');
gd.path.tracks{1,3} = fullfile(gd.picPath, 'tracks3.jpg');
gd.path.tracks{1,4} = fullfile(gd.picPath, 'tracks4.jpg');
%% Load ExptParams.mat
WordPicList = dir(gd.wordPath);
WordPicList(strcmp({WordPicList.name}, '.'))=[]; %remove folder '.'
WordPicList(strcmp({WordPicList.name}, '..'))=[]; % remove folder '..'

WordPicNum = length(WordPicList);

TotalNumBlocks = ConfigParams.Experiment.BaselineNumBlocks +...
               ConfigParams.Experiment.RampNumBlocks +...
               ConfigParams.Experiment.HoldNumBlocks +...
               ConfigParams.Experiment.WashoutNumBlocks;
ExptParams = setPhaseParamsHW(gd, TotalNumBlocks, @matchChange);


%% Add subject data folder to ExptParams
ExptParams.SubjectDataFolder = SubjectDataFolder;

%% Audapter Set Up
load('AudapterHWRefParams_SPEAK.mat', 'refp2');
ExptParams.p = refp2;
ExptParams.p.nDelay = 3;
ExptParams.p.rmsThresh = 0;

ExptParams.p.avgLen = 8;
ExptParams.p.aFact = 1;
ExptParams.p.bFact = 0.8;
ExptParams.p.gFact = 1;

ExptParams.p.nLPC = 15;
ExptParams.p.fn1 = 675;
ExptParams.p.fn2 = 1392;

ExptParams.p.sr = 16000;
ExptParams.p.sRate = 16000;
ExptParams.p.downfact = 3;
ExptParams.p.downFact = 3;
ExptParams.p.frameLen = 32;


if strcmp(ConfigParams.Experiment.PertUnit, 'Cent') || strcmp(ConfigParams.Experiment.PertUnit, '%')
    ExptParams.p.bRatioShift = 1;
    ExptParams.p.bMelShift = 0;
elseif strcmp(ConfigParams.Experiment.PertUnit, 'Hz')
    ExptParams.p.bRatioShift = 0;
    ExptParams.p.bMelShift = 0;
elseif strcmp(ConfigParams.Experiment.PertUnit, 'Mel')
    ExptParams.p.bRatioShift = 0;
    ExptParams.p.bMelShift = 1;
end

ExptParams.p.trialLen = 0; %Zero corresponds to no trial length limit. Data will be stored circularly.

AudioDriverName = ConfigParams.Audapter.AudioDriverName;

clear Audapter;
Audapter('deviceName', AudioDriverName);
Audapter('ost', '', 0);
Audapter('pcf', '', 0);

% Start of the trial: no perturbation, but turn ON Audapter
ExptParams.p.pertAmp = 0 * ones(1, ExptParams.p.pertFieldN);
ExptParams.p.pertPhi = 0 * ones(1, ExptParams.p.pertFieldN);

%% Add trial number and shift-related config params to ExptParams
ExptParams.BaselineTrials = WordPicNum*ConfigParams.Experiment.BaselineNumBlocks;
ExptParams.RampTrials = WordPicNum*ConfigParams.Experiment.RampNumBlocks;
ExptParams.HoldTrials = WordPicNum*ConfigParams.Experiment.HoldNumBlocks;
ExptParams.WashoutTrials = WordPicNum*ConfigParams.Experiment.WashoutNumBlocks;

if strcmp(ConfigParams.Experiment.PertType, 'Formant shift')
    ExptParams.ShiftType = 'Formant';
    if strcmp(ConfigParams.Experiment.PertUnit, 'Cent')
        MaxPertF1 = 2^(ConfigParams.Experiment.F1Shift/1200)-1;
        MaxPertF2 = 2^(ConfigParams.Experiment.F2Shift/1200)-1;
    elseif strcmp(ConfigParams.Experiment.PertUnit, '%')
        MaxPertF1 = ConfigParams.Experiment.F1Shift/100;
        MaxPertF2 = ConfigParams.Experiment.F2Shift/100;
    elseif strcmp(ConfigParams.Experiment.PertUnit, 'Hz') || strcmp(ConfigParams.Experiment.PertUnit, 'Mel')
        MaxPertF1 = ConfigParams.Experiment.F1Shift;
        MaxPertF2 = ConfigParams.Experiment.F2Shift;
    end

    PerturbF1 = zeros(ExptParams.BaselineTrials+ExptParams.RampTrials+ExptParams.HoldTrials+ExptParams.WashoutTrials, 1);
    PerturbF2 = zeros(ExptParams.BaselineTrials+ExptParams.RampTrials+ExptParams.HoldTrials+ExptParams.WashoutTrials, 1);
    for i=ExptParams.BaselineTrials+1:ExptParams.BaselineTrials+ExptParams.RampTrials
        PerturbF1(i) = (i-ExptParams.BaselineTrials)*MaxPertF1/(ExptParams.RampTrials+1);
        PerturbF2(i) = (i-ExptParams.BaselineTrials)*MaxPertF2/(ExptParams.RampTrials+1);
    end

    PerturbF1(ExptParams.BaselineTrials+ExptParams.RampTrials+1:ExptParams.BaselineTrials+ExptParams.RampTrials+ExptParams.HoldTrials) ...
        = repmat(MaxPertF1, ExptParams.HoldTrials, 1);
    PerturbF2(ExptParams.BaselineTrials+ExptParams.RampTrials+1:ExptParams.BaselineTrials+ExptParams.RampTrials+ExptParams.HoldTrials) ...
        = repmat(MaxPertF2, ExptParams.HoldTrials, 1);

    ExptParams.F1Shift = PerturbF1;
    ExptParams.F2Shift = PerturbF2;
elseif strcmp(ConfigParams.Experiment.PertType, 'Pitch shift')
    ExptParams.ShiftType = 'Pitch';
    ExptParams.p.bPitchShift = 1;
    ExptParams.p.BypassFmt = 1;
    
    if strcmp(ConfigParams.Experiment.PertUnit, 'Cent')
        MaxPertF0 = 2^(ConfigParams.Experiment.F0Shift/1200);
    elseif strcmp(ConfigParams.Experiment.PertUnit, '%')
        MaxPertF0 = ConfigParams.Experiment.F0Shift/100+1;
    end

    PerturbF0 = ones(ExptParams.BaselineTrials+ExptParams.RampTrials+ExptParams.HoldTrials+ExptParams.WashoutTrials, 1);
    for i=ExptParams.BaselineTrials+1:ExptParams.BaselineTrials+ExptParams.RampTrials
        PerturbF0(i) = 1+(i-ExptParams.BaselineTrials)*(MaxPertF0-1)/(ExptParams.RampTrials+1);
    end

    PerturbF0(ExptParams.BaselineTrials+ExptParams.RampTrials+1:ExptParams.BaselineTrials+ExptParams.RampTrials+ExptParams.HoldTrials) ...
        = repmat(MaxPertF0, ExptParams.HoldTrials, 1);

    ExptParams.F0Shift = PerturbF0;
elseif strcmp(ConfigParams.Experiment.PertType, 'Delay')
    ExptParams.ShiftType = 'Delay';
    ExptParams.p.BypassFmt = 1;
    
    MaxPertDelaySeconds = ConfigParams.Experiment.Delay/1000;
    MaxPertDelayFrame = round(MaxPertDelaySeconds/(ExptParams.p.frameLen/ExptParams.p.sr));

    PerturbDelay = zeros(ExptParams.BaselineTrials+ExptParams.RampTrials+ExptParams.HoldTrials+ExptParams.WashoutTrials, 1);
    for i=ExptParams.BaselineTrials+1:ExptParams.BaselineTrials+ExptParams.RampTrials
        PerturbDelay(i) = (i-ExptParams.BaselineTrials)*MaxPertDelayFrame/(ExptParams.RampTrials+1);
    end

    PerturbDelay(ExptParams.BaselineTrials+ExptParams.RampTrials+1:ExptParams.BaselineTrials+ExptParams.RampTrials+ExptParams.HoldTrials) ...
        = repmat(MaxPertDelayFrame, ExptParams.HoldTrials, 1);

    ExptParams.Delay = PerturbDelay;
end

%%
AudapterIO('init', ExptParams.p);
%% Game Setup
% Create a Figure Window
% change gd.conf.Position
vEdge = round(gd.w/32);
confX = round(0.5*gd.w-0.225*gd.h)-vEdge;
confY = round(0.55*gd.h)-round(6.75*vEdge)+(round(0.45*gd.h)+vEdge)+vEdge;
confWidth = round(0.45*gd.h)+vEdge;
ConfHeight = vEdge;
gd.conf.Position = [confX confY confWidth ConfHeight];

fig = uifigure('WindowState', gd.fig.WindowState, 'Position', gd.fig.Position);
gameUI = initPhase(fig, ExptParams, gd, @matchChange, @flipChange, @endChange);

%% Board Game Button Functions
    function matchChange(~,~)
        if not(strcmp(gameUI.path.buttons{gd.matchPresses}.word, gameUI.flipObj.currWord))
            nonMatch(gameUI.confObj);
            gameUI = nextCard(gameUI, gd);
        else
            pressed = 'match';
            gameUI = clearCard(gameUI, pressed);
            gameUI = nextCard(gameUI, gd);
            gd.matchPresses = gd.matchPresses +1;
        end
    end

    function flipChange(~,~)
        if gameUI.flipObj.flipPresses < 1
            incrState(gameUI.path.buttons{2});
            startGame(gameUI.flipObj);
            
            Audapter('start');
            
            if strcmp(ExptParams.ShiftType, 'Formant')
                CurrentShiftF1 = ExptParams.F1Shift(1);
                CurrentShiftF2 = ExptParams.F2Shift(1);

                CurrentShiftAmp = abs(CurrentShiftF1 + 1i * CurrentShiftF2); % In Audapter "pertAmp" terms
                CurrentShiftAngle = angle(CurrentShiftF1 + 1i * CurrentShiftF2); % In Audapter "pertPhi" terms

                ExptParams.p.pertAmp = CurrentShiftAmp * ones(1, ExptParams.p.pertFieldN);
                ExptParams.p.pertPhi = CurrentShiftAngle * ones(1, ExptParams.p.pertFieldN);
            elseif strcmp(ExptParams.ShiftType, 'Pitch')
                CurrentShiftF0 = ExptParams.F0Shift(1);
                ExptParams.p.pitchShiftRatio = CurrentShiftF0;
            elseif strcmp(ExptParams.ShiftType, 'Delay')
                CurrentDelay = ExptParams.Delay(1);
                ExptParams.p.delayFrames = CurrentDelay;
            end
            

            AudapterIO('init', ExptParams.p);
            Audapter('reset');
        else
            
            if strcmp(gameUI.path.buttons{gd.matchPresses}.word, gameUI.flipObj.currWord)
                skipMatch(gameUI.confObj);
            else
                pressed = 'flip';
                gameUI = clearCard(gameUI, pressed);
                gameUI = nextCard(gameUI, gd);
            end
        end
    end

    function endChange(~,~)
        Audapter('stop');
        close(fig);
    end
end