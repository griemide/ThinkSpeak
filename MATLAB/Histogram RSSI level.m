% Read sensor RSSI level data for the last 10 hours from a ThingSpeak channel and
% visualize level variations using the MATLAB HISTOGRAM function.

% Channel 261716 contains data from the af104.RSSI sensor, located
% in Bad Hersfeld, Germany. The data is collected once 15 seconds.
% Field 1 contains the relevant values for the evaluation.

% Channel ID to read data from
readChannelID = 261716;
% Field ID
FieldID = 1;

% Channel Read API Key 
% If your channel is private, then enter the read API
% Key between the '' below: 
readAPIKey = 'RIHJL67MV0AZ9VAO';

% Get data from field 1 for the last 10 hours = 10 x 60 minutes. 
% Learn more about the THINGSPEAKREAD function by going to
% the Documentation tab on the right side pane of this page.

tempF = thingSpeakRead(readChannelID, 'Fields', FieldID, 'NumMinutes', 10*60, 'ReadKey', readAPIKey);
histogram(tempF);
xlabel('RSSI');
ylabel('Number of Measurements');
title('Histogram of RSSI variation');
grid on