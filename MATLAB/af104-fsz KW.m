% af104-fsz KW
% M. Gries, 
% 2018-12-03: creation (new)
% 2018-12-03: calculations based on formulat below
%
% used channel fields
% Field 2 =  'S0 pulse duration [ms]'
%
% Ferrais-counter constants (ACTARIS type C114):
% TicksPerCycle = 400;
% RedTicksPerCycle = 16; (equals Field 2 value * 1000)
% CyclesPerKWh = 75;
% SecPerHour = 3600;
%
% Calculation (KW):
% KW = SecPerKWh / SecPerHour; SecPerKWh = CyclesPerKWh * SecPerCycle;
% SecPerCycle = 400 * (meanValue(field2) / 1000) / 16;
% 
% Example:
% meanValue(field2) =  1920 [ms]
% SecPerCycle =  48
% SecPerKWh = 75 * 48 = 3600
% KW = 3600 / 3600  = 1
%
% used MATLAB references
% https://de.mathworks.com/help/matlab/arithmetic.html
% https://www.mathworks.com/help/matlab/ref/annotationtextbox-properties.html

channel = 624220;
fields = 2;
NumPoints = 1;
fieldSamples = thingSpeakRead(channel, 'Fields', fields, 'NumPoints', NumPoints);

TicksPerCycle = 400;
RedTicksPerCycle = 16;
CyclesPerKWh = 75;
SecPerHour = 3600;

% fieldSamples array may contain Not A Number (NaN) values
% function mean will result in a NaN result if array contain one or more NaN
% due to licencing reasons for function nanmean use following workaround
fieldSamples(isnan(fieldSamples)) = [];
% hampel(fieldSamples, 10);   % only registered users
B = smoothdata(fieldSamples); % B

% Find the indices of elements which are not outliers (LOW)
cleanDataIndexMin = find(fieldSamples > 100);
% Select only elements that are not outliers (LOW)
cleanDataMin = fieldSamples(cleanDataIndexMin);

% Find the indices of elements which are not outliers (HIGH)
cleanDataIndexMax = find(cleanDataMin < 15000);
% Select only elements that are not outliers (HIGH)
cleanData = cleanDataMin(cleanDataIndexMax);

meanValue = round(mean(cleanData)); meanValue

% meanValue = 1920; % for test purposes only 
SecPerCycle = 400 * (meanValue / 1000) / 16; SecPerCycle
SecPerKWh = CyclesPerKWh * SecPerCycle;  SecPerKWh
KW = SecPerKWh / SecPerHour;  % KW
W = KW * 1000; 
W = round(W); W

%
% preparing printout
%
UOM = 'Watt';
UOMtyp = [' ' UOM ];
% use decimal values if pipette fuction used in windows paint app
r = 165/255;
g = 40/255;
b = 41/255;
textColor = [r g b];  % delete semicolon for printout

annotation('textbox',[0.0 0.2 0.9 0.6],...
 'HorizontalAlignment','right',...
 'VerticalAlignment','middle',...
 'LineStyle','none',...
 'String',[num2str(W,'%u') UOMtyp],...
 'Color',textColor,...
 'FontSize',52);

% EOF