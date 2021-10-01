function obj = makeGButton(fig, buttonData)
%MAKEGBUTTON Summary of this function goes here
%   Detailed explanation goes here

obj = uicontrol(fig, 'Style', 'pushbutton', 'Units', 'normalized',...
    'Position', buttonData.Position);

obj.String = buttonData.String;
obj.ForegroundColor = buttonData.ForegroundColor;
obj.FontSize = buttonData.FontSize;

end

