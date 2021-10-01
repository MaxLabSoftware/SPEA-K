classdef pathButton < handle
    properties 
        buttonObj
        matchImage
        word = '';
        postImage
        iniImage = '';
        buttonState = 0;
    end
    
    methods
        function pb = pathButton(buttonNum, matchCards, w, h, trackImages, starImage, targetImage, uf, fcnhandle)
            pb.buttonObj = uibutton(uf, 'push', 'ButtonPushedFcn', fcnhandle);
            pb.buttonObj.Text = '';
            pb.buttonObj.BackgroundColor = [1 1 1];
            pb.buttonObj.Enable = 'off';
            pb.buttonObj.Icon = '';
            
            if buttonNum == 1
                pb.matchImage = '';
            elseif buttonNum >= length(matchCards)+2
                pb.matchImage = '';
            else
                pb.matchImage = matchCards{buttonNum-1}.file; 
                pb.word = matchCards{buttonNum-1}.word;
            end
            
            assignPosition(buttonNum, w, h);
            assignPostImage(buttonNum, trackImages, starImage, targetImage);
    
            function assignPosition(buttonNum, w, h)
                buttonW = round(w/16);
                vEdge = round(buttonW/2);
                
                if buttonNum < 9
                    pb.buttonObj.Position = [vEdge h-round(1.75*vEdge)-(buttonNum*buttonW) buttonW buttonW];
                elseif buttonNum < 23
                    pb.buttonObj.Position = [vEdge+buttonW*(buttonNum-8) h-round(1.75*vEdge)-(8*buttonW) buttonW buttonW];
                elseif buttonNum < 30
                    pb.buttonObj.Position = [vEdge+buttonW*14 h-round(1.75*vEdge)+buttonW*(buttonNum-30) buttonW buttonW];
                else
                    pb.buttonObj.Position = [vEdge-buttonW*(buttonNum-43) h-round(1.75*vEdge)-buttonW buttonW buttonW];
                end
            end
            
            function assignPostImage(buttonNum, trackImages, starImage, targetImage)
                if mod((buttonNum-5), 4) == 0 && buttonNum ~= 1
                    pb.postImage = starImage;
                    pb.iniImage = targetImage;
                    pb.buttonObj.Icon = pb.iniImage;
                elseif buttonNum == 1
                    pb.buttonObj.Icon = trackImages{1};
                elseif buttonNum < 8
                    pb.postImage = trackImages{1};
                elseif buttonNum < 22
                    pb.postImage = trackImages{2};
                elseif buttonNum < 29
                    pb.postImage = trackImages{3};
                else
                    pb.postImage = trackImages{4};
                end
            end
        end
        
        function incrState(pb)   
            if pb.buttonState < 2
                if pb.buttonState %executes if pb.buttonState == 1
                    %switch from state 1 to state 2
                    pb.buttonObj.Enable = 'off';
                    pb.buttonObj.Icon = pb.postImage;
                else %executes if pb.buttonState == 0
                    %switch from state 0 to state 1
                    pb.buttonObj.Enable = 'on';
                    pb.buttonObj.Icon = pb.matchImage;
                end
                pb.buttonState = pb.buttonState + 1;
            end
        end
        
        function decrState(pb)
            if pb.buttonState > 0
                if pb.buttonState-1 %executes if pb.buttonState == 2
                    %switch from state 2 to state 1
                    pb.buttonObj.Enable = 'on';
                    pb.buttonObj.Icon = pb.matchImage;
                else %executes if pb.buttonState == 1
                    %switch from state 1 to state 0
                    pb.buttonObj.Enable = 'off';
                    pb.buttonObj.Icon = pb.iniImage;  
                end
                pb.buttonState = pb.buttonState - 1;
            end
        end
        
        function enable(pb)
            pb.buttonObj.Enable = 'on';
        end
        
        function disable(pb)
            pb.buttonObj.Enable = 'off';
        end
        
        function buttonPosition = getPosition(pb)
            buttonPosition = pb.buttonObj.Position;
        end
    end
end