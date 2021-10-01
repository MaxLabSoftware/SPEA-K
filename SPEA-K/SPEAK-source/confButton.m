classdef confButton < handle
    properties
        buttonObj
    end
    
    methods
        function cb = confButton(fig, conf_data)
            cb.buttonObj = uibutton(fig, 'state', 'Position', conf_data.Position,...
                'Text', conf_data.Text, 'BackgroundColor', conf_data.BackgroundColor,...
                'FontSize', conf_data.FontSize);
        end
        
        function nonMatch(cb)
            cb.buttonObj.Text = "Oops, those don't match!";
            cb.buttonObj.BackgroundColor = [0.635 0.078 0.184];
            cb.buttonObj.FontColor = [1 1 1];
        end
        
        function match(cb)
            cb.buttonObj.Text = 'Great job!';
            cb.buttonObj.BackgroundColor = [0.466 0.674 0.188];
            cb.buttonObj.FontColor = [1 1 1];
        end
        
        function win(cb)
            cb.buttonObj.Text = 'You matched all the words, great job!';
        end
        
        function skipMatch(cb)
            cb.buttonObj.Text = "Oops, those match!";
            cb.buttonObj.BackgroundColor = [0.635 0.078 0.184];
            cb.buttonObj.FontColor = [1 1 1];
        end
        
        function flip(cb)
            cb.buttonObj.Text = 'Flip through the cards to find matches';
            cb.buttonObj.BackgroundColor = [1 1 1];
            cb.buttonObj.FontColor = [0 0 0];
        end
        
        function flipEnd(cb)
            cb.buttonObj.Text = 'You made it through the all the words, great job!';
            cb.buttonObj.BackgroundColor = [0.494 0.184 0.556];
            cb.buttonObj.FontColor = [0.929 0.694 0.125];
        end
        
        function confPause(cb)
            cb.buttonObj.Text = "Please wait!";
            cb.buttonObj.BackgroundColor = [0 0.4470 0.7410];
            cb.buttonObj.FontColor = [1 1 1];
        end
        
        function repeat(cb)
            cb.buttonObj.Text = "Please say the word again";
            cb.buttonObj.BackgroundColor = [0.929 0.694 0.125];
            cb.buttonObj.FontColor = [1 1 1];
        end
    end
end