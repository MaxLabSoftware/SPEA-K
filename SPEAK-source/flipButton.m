classdef flipButton < handle
    properties
        buttonObj
        flipPresses = 0;
        wordList
        currWord = '';
        hidden = false;
    end
    
    methods
        function fb = flipButton(fig, w, h, flipCards, fcnhandle)
            fb.buttonObj = uibutton(fig, 'push', 'ButtonPushedFcn', fcnhandle);
            fb.wordList = flipCards;
            
            vEdge = round(w/32);
            fb.buttonObj.Position = [round(0.5*w-0.225*h)-vEdge round(0.55*h)-round(6.75*vEdge)+vEdge round(0.45*h)+vEdge round(0.45*h)+vEdge];
            fb.buttonObj.Text = sprintf("%s\n%s", "START", "GAME");
            fb.buttonObj.FontSize = 100;
            fb.buttonObj.FontColor = [1 1 1];
            fb.buttonObj.BackgroundColor = [0.466 0.674 0.188];
        end
        
        function startGame(fb)
            fb.buttonObj.Text = '';
            incrState(fb)
        end
        
        function hide(fb)
            fb.buttonObj.Icon = '';
            fb.buttonObj.Text = '';
            fb.buttonObj.BackgroundColor = [1 1 1];
            disable(fb);
            fb.hidden = true;
        end
        
        function updateImage(fb)
            fb.buttonObj.Icon = fb.wordList{fb.flipPresses}.file;
            fb.buttonObj.BackgroundColor = [1 1 1];
            fb.currWord = fb.wordList{fb.flipPresses}.word;
            fb.buttonObj.Text = sprintf(fb.currWord);
            fb.buttonObj.FontSize = 80;
            fb.buttonObj.FontColor = [0 0 0];
            fb.buttonObj.FontWeight = 'bold';
            fb.buttonObj.VerticalAlignment = 'top';
            fb.buttonObj.IconAlignment = 'bottom';
            enable(fb);
            fb.hidden = false;
        end
        
        function incrState(fb)
            if fb.flipPresses < length(fb.wordList)
                fb.flipPresses = fb.flipPresses + 1;
            end
            updateImage(fb)
        end
        
        function decrState(fb)
            if fb.flipPresses > 1
                fb.flipPresses = fb.flipPresses - 1;
            end
            updateImage(fb)
        end
        
        function enable(fb)
            fb.buttonObj.Enable = 'on';
        end
        
        function disable(fb)
            fb.buttonObj.Enable = 'off';
        end
    end
end