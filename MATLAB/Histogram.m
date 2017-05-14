% Read temperature for the last 10 hours from a ThingSpeak channel and
% visualize temperature variations using the MATLAB HISTOGRAM function.

% https://de.mathworks.com/help/matlab/ref/histogram.html

% Channel 12397 contains data from the MathWorks Weather Station, located
% in Natick, Massachusetts. The data is collected once every minute. Field
% 4 contains temperature data.

% Channel ID to read data from
readChannelID = 263535;
% Temperature Field ID
TemperatureFieldID = 2;

% Channel Read API Key 
% If your channel is private, then enter the read API
% Key between the '' below: 
readAPIKey = 'EKA45PCKK9A7X0XM';

% Get temperature data from field 4 for the last 10 hours = 10 x 60
% minutes. Learn more about the THINGSPEAKREAD function by going to
% the Documentation tab on the right side pane of this page.

tempF = thingSpeakRead(readChannelID, 'Fields', TemperatureFieldID, 'NumPoints', 3073, 'ReadKey', readAPIKey);

%example R2.33 temperatur color #39a684
col = [0.224 0.651 0.518]

%example R2.33 temperatur color #39a684
r = hex2dec('39')/255
g = hex2dec('a6')/255
b = hex2dec('84')/255
faceCol = [r g b]

histogram(tempF,'FaceColor',faceCol);
xlabel('Temperature (°C)');
ylabel('Number of Measurements');
title('Histogram of Temperature variation');
grid on
