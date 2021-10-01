function phaseData = clearCard(phaseData, pressedButton)
%CLEARCARD Summary of this function goes here
%   Detailed explanation goes here

hide(phaseData.flipObj);
phaseData.buttonPresses = phaseData.buttonPresses + 1;

phaseData.buttonPressed{phaseData.buttonPresses} = pressedButton;

if strcmp(phaseData.buttonPressed{phaseData.buttonPresses}, 'match')
    match(phaseData.confObj);
    phaseData.dinoButton.Position = getPosition(phaseData.path.buttons{phaseData.matchPresses});
    incrState(phaseData.path.buttons{phaseData.matchPresses});
    
    if ~(phaseData.matchPresses <= phaseData.numMatch+1)
        if strcmp(gd.picSet, 'bike')
            phaseData.dinoButton.Visible = 'off';
        end
    end
else
    flip(phaseData.confObj);
    disable(phaseData.path.buttons{phaseData.matchPresses});
end
end