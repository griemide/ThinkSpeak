% Template MATLAB code for visualizing data using the THINGSPEAKPLOTYY
% function.

% https://de.mathworks.com/help/thingspeak/thingspeakplotyy.html

% Prior to running this MATLAB code template, assign the channel ID to read
% data from to the 'readChannelID' variable. Also, assign the field IDs
% within the channel that you want to read data from to 'fieldID1', and
% 'fieldID2'.

% TODO - Replace the [] with channel ID to read data from:
readChannelID = 263535;
% TODO - Replace the [] with the Field ID to read data from:
fieldID1 = 1;
% TODO - Replace the [] with the Field ID to read data from:
fieldID2 = 2;

% Channel Read API Key 
% If your channel is private, then enter the read API
% Key between the '' below: 
readAPIKey = 'EKA45PCKK9A7X0XM';

%% Configuration
sampleRatePerHour = 4;
samplesPerDay = sampleRatePerHour * 24;
DaysToDisplay = 30;
numPointsTotal = samplesPerDay * DaysToDisplay;
% whos numPointsTotal; 
disp(numPointsTotal);

% Define start time for period of interest and set timezone
start_time = datetime('26-Nov-2015 00:00:00', 'TimeZone', 'UTC');
% Define end time for period of interest and set timezone
end_time = datetime('30-Nov-2015 11:59:59', 'TimeZone', 'UTC');

% Read data from field 1 of channel 12397 for the daterange of interest.
% [data, time] = thingSpeakRead(12397, 'Fields', 1, 'DateRange', [start_time, end_time]);


%% Read Data %%

% Read first data variable
[data1, time1] = thingSpeakRead(readChannelID, 'Field', fieldID1, 'NumPoints', numPointsTotal, 'ReadKey', readAPIKey);

% Read second data variable
[data2, time2] = thingSpeakRead(readChannelID, 'Field', fieldID2, 'NumPoints', numPointsTotal, 'ReadKey', readAPIKey);
% whos time1;

% example R2.33 humidity color #9c416b
r = hex2dec('9c')/255;
g = hex2dec('41')/255;
b = hex2dec('6b')/255;
col1 = [r g b]

%example R2.33 temperatur color #39a684
r = hex2dec('39')/255;
g = hex2dec('a6')/255;
b = hex2dec('84')/255;
col2 = [r g b]

%% Visualize Data %%
thingSpeakPlotYY(time1, data1, time2, data2,'Color1',col1,'Color2',col2,'grid','on','LineWidth1',2,'LineWidth2',2);
