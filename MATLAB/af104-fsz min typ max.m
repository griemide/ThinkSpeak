% af104-fsz min typ max
% M. Gries, 
% 2018-12-03: creation (granted from af104-rkz min typ max)
% 2018-12-03: parameters changed to channel 624220 (af104-fsz)
% 2018-12-06: statistics changes from 1000 NumPoints to 1 day to fit with histogram)
%
% used for channel application af104-fsz min-typ-max values
% Field 2 =  'S0 pulse duration [ms]'
% https://de.mathworks.com/help/matlab/arithmetic.html
% http://www.mathworks.com/help/matlab/ref/annotationtextbox-properties.html

channel = 624220;
fields = 2;
NumPoints = 24*60; % equals 1 day
fieldSamples = thingSpeakRead(channel, 'Fields', fields, 'NumMinutes', NumPoints);

% Channel color used in channel field config window: #317db5
% r = hex2dec('31')/255;
% g = hex2dec('7d')/255;
% b = hex2dec('b5')/255;

% use decimal values if pipette function used in windows paint app
r = 165/255;
g = 40/255;
b = 41/255;
textColor = [r g b]; 
% display(textColor, 'selected color pattern'); % for test porposes only

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
cleanDataIndexMax = find(cleanDataMin < 15000);
% Select only elements that are not outliers (HIGH)
cleanData = cleanDataMin(cleanDataIndexMax);
display(numel(cleanData), 'Number of pulses after cleaning');

maxValue = max(cleanData);
meanValue = round(mean(cleanData));
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
 'String',[num2str(meanValue,'%u') UOMtyp],...
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

annotation('textbox',[0.0 0.0 0.9 0.6],...
 'FontName','FixedWidth',...
 'HorizontalAlignment','center',...
 'VerticalAlignment','bottom',...
 'LineStyle','none',...
 'String','Note: values between >100 and <15000 msec considered',...
 'Color','0.5 0.5 0.5',...
 'FontSize',10);
 
 % EOF
