function params = setPhaseParamsHW(gameData, numRepeats, matchCallback)
%SETPHASEPARAMS Summary of this function goes here
%   Detailed explanation goes here
params = struct;

% set to initial value
params.matchPresses = gameData.matchPresses;
params.buttonPresses = gameData.buttonPresses;
params.pauseVal = 0;

% create word lists
params.totalWords = gameData.numWords * numRepeats;
[params.matchCards, params.flipCards, params.numMatch] = createWordListsHW(numRepeats, gameData.imPath, gameData.wordPath);

params.buttonPressed = cell(params.totalWords,1);
gameData.path.buttons = cell(params.numMatch,1);

% make temp figure to determine location of first and last path buttons
fig = uifigure;
fig.WindowState = gameData.fig.WindowState;
fig.Position = gameData.fig.Position;
fig.Resize = gameData.fig.Resize;

first = pathButton(1, params.matchCards, gameData.w, gameData.h, gameData.path.tracks, gameData.path.star, gameData.path.target, fig, matchCallback);
last = pathButton(params.numMatch, params.matchCards, gameData.w, gameData.h, gameData.path.tracks, gameData.path.star, gameData.path.target, fig, matchCallback);

if params.numMatch < 9
    addNestPos = [0 -gameData.buttonW 0 0];
elseif params.numMatch < 23
    addNestPos = [gameData.buttonW 0 0 0];
elseif params.numMatch < 30
    addNestPos = [0 gameData.buttonW 0 0];
else
    addNestPos = [-gameData.buttonW 0 0 0];
end

params.nest.Position = getPosition(last) + addNestPos;
params.nest.Text = '';
params.nest.BackgroundColor = [1 1 1];
params.nest.Icon = strcat(gameData.picPath, 'end.jpg');

params.dino.Position = getPosition(first);
params.dino.Text = '';
params.dino.BackgroundColor = [1 1 1];
params.dino.Icon = strcat(gameData.picPath, 'char1.jpg');

close(fig);
end

