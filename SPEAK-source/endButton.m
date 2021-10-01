classdef endButton < handle
    properties
        buttonObj
        hidden = false;
    end
    
    methods
        function fb = endButton(fig, w, h, fcnhandle)
            fb.buttonObj = uibutton(fig, 'push', 'ButtonPushedFcn', fcnhandle);
            
            vEdge = round(w/32);
            fb.buttonObj.Position = [round(w-0.225*h)-vEdge vEdge 3*vEdge vEdge];
            fb.buttonObj.Text = sprintf("End");
            fb.buttonObj.FontSize = 20;
            fb.buttonObj.FontColor = [0 0 0];
            fb.buttonObj.BackgroundColor = [1 1 1];
            fb.buttonObj.FontAngle = 'italic';
            fb.buttonObj.FontWeight = 'bold';
        end 
    end
end