% Script to initialize game, data saved to struct
gd = struct;

% Set pauseLen to 4s, minPause to 0.5s when not testing
gd.pauseLen = 6;
gd.minPause = 0.5;

% Directory with game
% gd.gamedir = '/home/maxlab/LSPMCserver/ResearchSoftware/Matlab/PicPresentTouchScreen/currGame/';
gd.gamedir = 'C:\Users\franc\MATLAB Drive\'; %Windows

gd.picSet = 'dino'; %currently dino or bike
gd.imPath = strcat(gd.gamedir, 'images/word_pics/');
gd.wordPath = strcat(gd.gamedir, 'images/words/');
gd.picPath = strcat(gd.gamedir, strcat('images/', strcat(gd.picSet, '/')));

gd.matchPresses = 2;
gd.buttonPresses = 0;
gd.pauseVal = 0;

gd.numWords = 6;

% Measure size of screen
screens = get(0, 'MonitorPositions');
screen1 = screens(1,:);
gd.w = screen1(3) * (2/3); %changed to make smaller????
gd.h = screen1(4) * (3/4);
hw = gd.h / gd.w; %~1.6

% figure settings
% gd.fig.WindowState = 'maximized'; 
% gd.fig.Position = screens(1,:); 

gd.fig.WindowState = 'normal';
gd.fig.Position = [0 0 gd.w gd.h];

gd.fig.Resize = 'off';
% fig.Visible = 'off';

%%% Buttons %%%
gd.buttonW = round(gd.w/16);

gd.vEdge = round(gd.buttonW/2);

% use imageObject instead??????
gd.path.tracks = {strcat(gd.picPath, 'tracks1.jpg'), strcat(gd.picPath, 'tracks2.jpg'), ...
        strcat(gd.picPath, 'tracks3.jpg'), strcat(gd.picPath, 'tracks4.jpg')};
gd.path.star = strcat(gd.picPath, 'star.jpg');
gd.path.target = strcat(gd.picPath, 'target.jpg');

gd.conf.Position = [round(0.5*gd.w-0.225*gd.h)-gd.vEdge gd.h-round(5.75*gd.vEdge) round(0.45*gd.h)+gd.vEdge gd.vEdge];
if strcmp(gd.picSet, 'dino')
    gd.conf.Text = 'Help the dino find its missing eggs!';
    gd.conf.FontSize = 18;
elseif strcmp(gd.picSet, 'bike')
    gd.conf.Text = 'Help Dr. Max eat sandwiches to get energy for the bike race!';
    gd.conf.FontSize = 18;
end
gd.conf.BackgroundColor = [1 1 1];

save('gameData.mat', 'gd')
close all force;
