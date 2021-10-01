function pauseVal = pauseGame(pauseButton, flipObj, pathButtons, matchPresses, confObj)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

pauseVal = 1;
pauseButton.ForegroundColor = 'w';
pauseButton.BackgroundColor = 'b';
disable(flipObj);
disable(pathButtons{matchPresses});

confPause(confObj);
end

