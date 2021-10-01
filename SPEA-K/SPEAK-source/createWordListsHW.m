function [matchCards, flipCards, numMatch] = createWordListsHW(repeats, imPath, wordPath)
%CREATEWORDLISTS Create list of match cards and cards to flip through in
%                order to rig the game.
% note: word list is used to denote the set of unique words used in exp,
%       word set is used to denote a specific instance usage of word list
% input: repeats (double) # of times word list is repeated in experiment
% output: matchCards (cell array) list of words that subject will try to
%         "match" in order to win game
%         flipCards (cell array) list of words that subject will say during 
%         the experiment and try to "match" to the matchCards

%%% remove and have as input
%imgList = {'bug.jpg', 'bus.jpg', 'cup.jpg', 'cut.jpg', 'duck.jpg', 'pup.jpg'};

WordPicList = dir(imPath);
WordPicList(strcmp({WordPicList.name}, '.'))=[]; %remove folder '.'
WordPicList(strcmp({WordPicList.name}, '..'))=[]; % remove folder '..'

imgList = cell(1, length(WordPicList));
for i = 1:length(WordPicList)
    imgList{1,i} = WordPicList(i).name;
end

matchCards = createMatchList(imgList, repeats);
numWords = length(imgList);

%%% see about adjusting mps1 and mps2?
%%% really should do especially for larger word lists

% matches per word set (mps), initially has fewer mps at start of game
mps1 = 2;
mps2 = 3;

flipCards = cell(0);

% edge dilemma detection and correction
for n = 1:repeats-1
    if strcmp(matchCards{numWords*n}, matchCards{numWords*n+1})
        matchCards{numWords*n+1} = matchCards{numWords*n+2};
        matchCards{numWords*n+2} = matchCards{numWords*n};
    end
end

for m = 1:repeats

    % go through match set and get list of mps words to match in curr set
    if m < 15 %%% based on screen size and word list? ideally should replace
        matchSet = matchCards((m-1)*mps1+1:m*mps1);
    else
        matchSet = matchCards((m-15)*mps2+28:(m-14)*mps2+27);
    end
    
    % seperate words that don't match current matches from word list
    other = setdiff(imgList, matchSet);
    other = other(randperm(length(other)));
    
    % ~randomly select indices for matches, one match will always be at end 
    %   in order to avoid the edge dilemma
    indices = 1:numWords-1;
    rng('shuffle');
    shuffIndex = indices(randperm(length(indices)));
    
    % take first mps-1 indices for matches
    if m < 15
        matchIndex = shuffIndex(1:mps1-1);
    else
        matchIndex = shuffIndex(1:mps2-1);
    end
    
    % sort match index and add index for last word
    matchIndex = [sort(matchIndex) numWords];
    
    % assign flipCards based off selected indices for matches
    matchNum = 1; % starting index for match in matchSet
    otherNum = 1; % starting index for other word in other
    flipCardsTemp = cell(1, numWords);
    for n = 1:numWords
        if m < 15 % fewer mps (mps1)
            if matchNum <= mps1 && n == matchIndex(matchNum)
                flipCardsTemp(n) = matchSet(matchNum);
                matchNum = matchNum + 1;
            else
                flipCardsTemp(n) = other(otherNum);
                otherNum = otherNum + 1;
            end
        else % more mps (mps2)
            if matchNum <= mps2 && n == matchIndex(matchNum)
                flipCardsTemp(n) = matchSet(matchNum);
                matchNum = matchNum + 1;
            else
                flipCardsTemp(n) = other(otherNum);
                otherNum = otherNum + 1;
            end
        end
    end
    flipCards = [flipCards flipCardsTemp];
end
numMatch = countMatches(matchCards, flipCards);
for n=1:length(flipCards)
    flipCards{n} = imageObject(wordPath, flipCards{n});
    matchCards{n} = imageObject(imPath, matchCards{n});
end
end

function imageCards = createMatchList(imageCell, repeats)
%CREATECARDLIST Creates list of images to be used as matching set in game
% note: match list is created s.t. list of words is shuffled and then added 
%       to the match list (i.e. original list is shuffled and then added, 
%       original list is shuffled and added, and so on)
% input: imageCell (cell array) list of image names (str)
%        repeats (int) # of times word list is repeated in experiment
% output: imageCards (cell array) list of shuffled word sets, repeated by 
%         number of repeats

%%% preallocate imageCards for speed??
imageCards = cell(0);
for n = 1:repeats
    imageCards = [imageCards imageShuffle(imageCell)];
end
end

function shuffledImages = imageShuffle(imageCell)
%IMAGESHUFFLE Randomly shuffles a cell array using random permutation
% input: imageCell (cell array) list of image names (str)
% output: shuffledImages (cell array) permutated imageCell

rng('shuffle');
shuffledImages = imageCell(randperm(length(imageCell)));
end

function numMatch = countMatches(matchCards, flipCards)
%COUNTMATCHES Counts the number of matches possible for a given flipCard
%             and matchCard set
% input: matchCards (cell array) list of words that subject will try to
%        "match" in order to win game
%        flipCards (cell array) list of words that subject will say during 
%        the experiment and try to "match" to the matchCards
% output: numMatch (int) # of matches possible when flipping through items
%         in flipCards and matching them to matchCards

numMatch = 1;
for n = 1:length(flipCards)
    if strcmp(flipCards{n}, matchCards{numMatch})
        numMatch = numMatch + 1;
    end
end
end