% Read temperature and humidity from a ThingSpeak channel and visualize the
% relationship between them using the MATLAB THINGSPEAKSCATTER plot

% https://de.mathworks.com/help/thingspeak/thingspeakscatter.html

% Channel 12397 contains data from the MathWorks Weather Station, located
% in Natick, Massachusetts. The data is collected once every minute. Field
% 3 contains the humidity data and field 4 contains temperature data.

% Channel ID to read data from
readChannelID = 263535;
% Temperature Field ID
TemperatureFieldID = 2;
% Humidity Field ID
HumidityFieldID = 1;

% Channel Read API Key 
% If your channel is private, then enter the read API
% Key between the '' below: 
readAPIKey = 'EKA45PCKK9A7X0XM';

% Read Temperature Data. Learn more about the THINGSPEAKREAD function by
% going to the Documentation tab on the right side pane of this page.

temperatureData = thingSpeakRead(readChannelID, 'Fields', TemperatureFieldID, 'NumPoints', 3073, 'ReadKey', readAPIKey);

% Read Humidity Data
humidityData = thingSpeakRead(readChannelID, 'Fields', HumidityFieldID, 'NumPoints', 3073, 'ReadKey', readAPIKey);

% Learn more about the THINGSPEAKSCATTER function by going to the
% Documentation tab on the right side pane of this page.
s = linspace(1,10,length(temperatureData));
c = linspace(0,10,length(temperatureData));

% thingSpeakScatter(temperatureData, humidityData, s, c, 'xlabel', 'Temperature', 'ylabel', 'Humidity');
thingSpeakScatter(temperatureData, humidityData, s, c, 'xlabel', 'Temperature [°C]', 'ylabel', 'Humidity [%rh]');
