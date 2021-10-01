function obj = makeAButton(fig, buttonData)
%MAKEABUTTON Summary of this function goes here
%   Detailed explanation goes here

obj = uibutton(fig, 'push', 'Position', buttonData.Position); 

if isfield(buttonData, 'Text')
    obj.Text = buttonData.Text;
end

if isfield(buttonData, 'BackgroundColor')
    obj.BackgroundColor = buttonData.BackgroundColor;
end

if isfield(buttonData, 'Icon')
    obj.Icon = buttonData.Icon; 
end

end