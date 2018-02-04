% af104-rkz
% M. Gries, 
% 2017-07-11: creation
% 2018-02-04: FontSize changed (72 to 52) due to MATLAB visualization changes
%
% used for channel application af104-rkz min-typ-max values
% code derived of af104-fsk
% Field 2 =  'D1 Pulse'
% http://www.mathworks.com/help/matlab/ref/annotationtextbox-properties.html

channel = 296355;
fields = 2;
NumPoints = 1000;
fieldSamples = thingSpeakRead(channel, 'Fields', fields, 'NumPoints', NumPoints);

% Channel color used in channel field config window: #317db5
% r = hex2dec('31')/255;
% g = hex2dec('7d')/255;
% b = hex2dec('b5')/255;

% use decimal values if pipette fuction used in windows paint app
r = 165/255;
g = 40/255;
b = 41/255;
textColor = [r g b]  % print output

% fieldSamples array may contain Not A Number (NaN) values
% function mean will result in a NaN result if array contain one or more NaN
% due to licencing reasons for function nanmean use following workaround
fieldSamples(isnan(fieldSamples)) = [];
% hampel(fieldSamples, 10);   % only registered users
B = smoothdata(fieldSamples);

% Find the indices of elements which are not outliers (LOW)
cleanDataIndexMin = find(fieldSamples > 100);
% Select only elements that are not outliers (LOW)
cleanDataMin = fieldSamples(cleanDataIndexMin);

% Find the indices of elements which are not outliers (HIGH)
cleanDataIndexMax = find(cleanDataMin < 2999);
% Select only elements that are not outliers (HIGH)
cleanData = cleanDataMin(cleanDataIndexMax);

maxValue = max(cleanData);
meanValue = mean(cleanData);
minValue = min(cleanData);

UOM = 'msec';
UOMmin = [' ' UOM ' (min)'];
UOMtyp = [' ' UOM ];
UOMmax = [' ' UOM ' (max)'];

annotation('textbox',[0.0 0.4 0.9 0.6],...
 'HorizontalAlignment','right',...
 'VerticalAlignment','middle',...
 'LineStyle','none',...
 'String',[num2str(maxValue,'%u') UOMmax],...
 'Color','0.5 0.5 0.5',...
 'FontSize',28);
 
annotation('textbox',[0.0 0.2 0.9 0.6],...
 'HorizontalAlignment','right',...
 'VerticalAlignment','middle',...
 'LineStyle','none',...
 'String',[num2str(meanValue, 3) UOMtyp],...
 'Color',textColor,...
 'FontSize',52);
 
annotation('textbox',[0.0 0.0 0.9 0.6],...
 'FontName','FixedWidth',...
 'HorizontalAlignment','right',...
 'VerticalAlignment','middle',...
 'LineStyle','none',...
 'String',[num2str(minValue,'%u') UOMmin],...
 'Color','0.5 0.5 0.5',...
 'FontSize',28);

annotation('textbox',[0.1 0.1 0.9 0.6],...
 'FontName','FixedWidth',...
 'HorizontalAlignment','center',...
 'VerticalAlignment','bottom',...
 'LineStyle','none',...
 'String','Note:  only values between < 2999 and > 100 considered',...
 'Color','0.5 0.5 0.5',...
 'FontSize',12);
 