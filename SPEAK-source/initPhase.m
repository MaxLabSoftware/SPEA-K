function phaseData = initPhase(fig, phaseData, gameData, matchCallback, flipCallback, endCallback)
%INITPHASE Summary of this function goes here
%   Detailed explanation goes here

%%% Score Buttons %%%
for n = 1:phaseData.numMatch+1
    phaseData.path.buttons{n} = pathButton(n, phaseData.matchCards, gameData.w, gameData.h, gameData.path.tracks, ...
        gameData.path.star, gameData.path.target, fig, matchCallback);
end

%%% Change the nest position to the end of the track
phaseData.nest.Position = phaseData.path.buttons{1, phaseData.numMatch+1}.buttonObj.Position;

phaseData.nestButton = makeAButton(fig, phaseData.nest);
phaseData.dinoButton = makeAButton(fig, phaseData.dino);

phaseData.confObj = confButton(fig, gameData.conf);
phaseData.flipObj = flipButton(fig, gameData.w, gameData.h, phaseData.flipCards, flipCallback);

phaseData.endObj = endButton(fig, gameData.w, gameData.h, endCallback);

end

