function gameUI = nextCard(gameUI, gameData)
%NEXTCARD Summary of this function goes here
%   Detailed explanation goes here

if ~gameUI.flipObj.hidden
    if strcmp(gameUI.path.buttons{gameUI.matchPresses}.word, gameUI.flipObj.currWord)
        pressed = 'match';
    else 
        pressed = 'flip';
    end
    gameUI = clearCard(gameUI, pressed);
end

pause(gameData.minPause);

%   Extract Audapter data from last trial & save
data = AudapterIO('getData');
SubjectDataFolder = gameUI.SubjectDataFolder;
CurrentTrialNumber = gameUI.flipObj.flipPresses;
CurrentWord = gameUI.flipCards{1, CurrentTrialNumber}.word;

if strcmp(gameUI.ShiftType, 'Formant')
    CurrentF1Shift = gameUI.F1Shift(CurrentTrialNumber);
    CurrentF2Shift = gameUI.F2Shift(CurrentTrialNumber);

    SaveDataFileName = fullfile(SubjectDataFolder, [num2str(CurrentTrialNumber),...
        '_', CurrentWord,...
        '_', num2str(CurrentF1Shift),...
        '_', num2str(CurrentF2Shift),'.mat']);
    save(SaveDataFileName, 'data');
elseif strcmp(gameUI.ShiftType, 'Pitch')
    CurrentF0Shift = gameUI.F0Shift(CurrentTrialNumber);
    SaveDataFileName = fullfile(SubjectDataFolder, [num2str(CurrentTrialNumber),...
        '_', CurrentWord,...
        '_', num2str(CurrentF0Shift),'.mat']);
    save(SaveDataFileName, 'data');
elseif strcmp(gameUI.ShiftType, 'Delay')
    CurrentDelay = gameUI.Delay(CurrentTrialNumber);
    SaveDataFileName = fullfile(SubjectDataFolder, [num2str(CurrentTrialNumber),...
        '_', CurrentWord,...
        '_', num2str(CurrentDelay),'.mat']);
    save(SaveDataFileName, 'data');
end


if strcmp(gameUI.buttonPressed{gameUI.buttonPresses}, 'match')
    if (gameUI.matchPresses < gameUI.numMatch)
        gameUI.matchPresses = gameUI.matchPresses + 1;
        incrState(gameUI.path.buttons{gameUI.matchPresses});
        incrState(gameUI.flipObj);
           
       if strcmp(gameUI.ShiftType, 'Formant')
            CurrentShiftF1 = gameUI.F1Shift(gameUI.flipObj.flipPresses);
            CurrentShiftF2 = gameUI.F2Shift(gameUI.flipObj.flipPresses);

            CurrentShiftAmp = abs(CurrentShiftF1 + 1i * CurrentShiftF2); % In Audapter "pertAmp" terms
            CurrentShiftAngle = angle(CurrentShiftF1 + 1i * CurrentShiftF2); % In Audapter "pertPhi" terms

            gameUI.p.pertAmp = CurrentShiftAmp * ones(1, gameUI.p.pertFieldN);
            gameUI.p.pertPhi = CurrentShiftAngle * ones(1, gameUI.p.pertFieldN);
        elseif strcmp(gameUI.ShiftType, 'Pitch')
            CurrentShiftF0 = gameUI.F0Shift(gameUI.flipObj.flipPresses);
            gameUI.p.pitchShiftRatio = CurrentShiftF0;
        elseif strcmp(gameUI.ShiftType, 'Delay')
            CurrentDelay = gameUI.Delay(gameUI.flipObj.flipPresses);
            gameUI.p.delayFrames = CurrentDelay;
        end

        AudapterIO('init', gameUI.p);
        Audapter('reset');
    else
        Audapter('stop');
        win(gameUI.confObj);
        gameUI.nestButton.Icon = strcat(gameData.picPath, 'end_win.jpg');

        if strcmp(gameData.picSet, 'bike')
            pause(0.2)
            for m=1:(gameUI.numMatch-10) %need to find correct stopping point
                gameUI.nestButton.Position = gameUI.nestButton.Position - [gameUI.vEdge*m 0 0 0];
                pause(0.15)
            end
        end

        gameUI.flipObj.buttonObj.Icon = strcat(gameData.picPath, 'win.jpg');
    end
else 
    if ~(gameUI.flipObj.flipPresses == gameUI.totalWords)
        
        enable(gameUI.path.buttons{gameUI.matchPresses});
        incrState(gameUI.flipObj);
        
        if strcmp(gameUI.ShiftType, 'Formant')
            CurrentShiftF1 = gameUI.F1Shift(gameUI.flipObj.flipPresses);
            CurrentShiftF2 = gameUI.F2Shift(gameUI.flipObj.flipPresses);

            CurrentShiftAmp = abs(CurrentShiftF1 + 1i * CurrentShiftF2); % In Audapter "pertAmp" terms
            CurrentShiftAngle = angle(CurrentShiftF1 + 1i * CurrentShiftF2); % In Audapter "pertPhi" terms

            gameUI.p.pertAmp = CurrentShiftAmp * ones(1, gameUI.p.pertFieldN);
            gameUI.p.pertPhi = CurrentShiftAngle * ones(1, gameUI.p.pertFieldN);
        elseif strcmp(gameUI.ShiftType, 'Pitch')
            CurrentShiftF0 = gameUI.F0Shift(gameUI.flipObj.flipPresses);
            gameUI.p.pitchShiftRatio = CurrentShiftF0;
        elseif strcmp(gameUI.ShiftType, 'Delay')
            CurrentDelay = gameUI.Delay(gameUI.flipObj.flipPresses);
            gameUI.p.delayFrames = CurrentDelay;
        end

        AudapterIO('init', gameUI.p);
        Audapter('reset');
    else
        Audapter('stop');
        flipEnd(gameUI.confObj);
    end
end
end

