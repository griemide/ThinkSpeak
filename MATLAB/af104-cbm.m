% af104-rkz cbm - get latest quantity of used water [liter]

author = 'M. Gries'; author
version = '17.7.12'; version

readChannelID = 296355;
FieldID = 1;

liter = thingSpeakRead(readChannelID, 'Fields', FieldID, 'NumPoints', 1); 

display(liter);

UOM = 'Liter';

% Channel color used in channel field config window: #317db5
r = hex2dec('31')/255;
g = hex2dec('7d')/255;
b = hex2dec('b5')/255;
textColor = [r g b]; 

annotation('textbox',[0.0 0.2 0.9 0.6],...
 'HorizontalAlignment','right',...
 'VerticalAlignment','middle',...
 'LineStyle','none',...
 'String',[num2str(liter) ' ' UOM],...
 'Color',textColor,...
 'FontSize',72);